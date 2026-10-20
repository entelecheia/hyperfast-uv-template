#!/usr/bin/env bash
# Render the template in each supported variant and run the generated project's gate.
# Works with or without .git in this repository (CI checkout or a bare exported tree).
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
copier=(uvx "copier@${COPIER_VERSION:-9.19.1}")
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

common=(
  -d project_name=demo-pkg -d project_short_description=Demo -d project_description=Demo
  -d author="Test User" -d github_username=tester -d email=test@example.com
)
vcs_ref=()
if git -C "$root" rev-parse --git-dir >/dev/null 2>&1; then
  # A git template renders from its latest tag unless told otherwise; HEAD includes local changes.
  vcs_ref=(--vcs-ref=HEAD)
fi

fail() { echo "render-test: $*" >&2; exit 1; }

render() { # <variant> [copier args...]
  local out="$work/$1"; shift
  "${copier[@]}" copy --quiet --trust --defaults "${vcs_ref[@]}" "${common[@]}" "$@" "$root" "$out" >/dev/null
  echo "$out"
}

check_tree() { # <dir>: no unrendered Jinja, no CLAUDE.md, workflow standard
  local out=$1
  [ -f "$out/AGENTS.md" ] && [ -f "$out/REVIEW.md" ] || fail "$out: AGENTS.md or REVIEW.md missing"
  [ ! -e "$out/CLAUDE.md" ] || fail "$out: CLAUDE.md present"
  uv run --no-project --with "pyyaml>=6" python - "$out" <<'PY'
import pathlib, re, sys, yaml

out = pathlib.Path(sys.argv[1])
errors = []
for path in out.rglob("*"):
    if ".git" in path.parts or not path.is_file():
        continue
    text = path.read_text(errors="ignore")
    # GitHub expressions use ${{ ... }}; anything else is an unrendered Jinja tag.
    if re.search(r"(?<!\$)\{\{|\{%", text):
        errors.append(f"unrendered Jinja in {path.relative_to(out)}")
for wf in sorted((out / ".github/workflows").glob("*.yaml")):
    doc = yaml.safe_load(wf.read_text())
    for name, job in doc.get("jobs", {}).items():
        if "uses" not in job and "timeout-minutes" not in job:
            errors.append(f"{wf.name}: job {name} has no timeout-minutes")
        for step in job.get("steps", []):
            ref = step.get("uses", "")
            if ref and not re.fullmatch(r"[\w.-]+/[\w./-]+@[0-9a-f]{40}", ref):
                errors.append(f"{wf.name}: job {name} uses an action not pinned by SHA: {ref}")
    if "pull_request" in (doc.get(True) or doc.get("on") or {}):
        if "cancel-in-progress" not in str(doc.get("concurrency", "")):
            errors.append(f"{wf.name}: pull_request workflow does not cancel superseded runs")
print("\n".join(errors) or f"{out.name}: tree checks passed")
sys.exit(1 if errors else 0)
PY
}

gate() { # <dir> [extra make targets...]: run the generated gate without .git
  local out=$1; shift
  rm -rf "$out/.git"
  make -C "$out" install verify "$@"
}

# 1. Defaults: no docs site.
out=$(render default)
[ "$(git -C "$out" remote get-url origin)" = "https://github.com/tester/demo-pkg.git" ] || fail "origin remote not set"
[ "$(git -C "$out" branch --show-current)" = "main" ] || fail "initial branch is not main"
[ ! -e "$out/mkdocs.yaml" ] && [ ! -e "$out/docs" ] && [ ! -e "$out/.github/workflows/docs.yaml" ] \
  || fail "docs files rendered with docs_tool=none"
[ -L "$out/.github/workflows/lint_and_test.yaml" ] && fail "workflow rendered as a symlink"
check_tree "$out"
gate "$out"

# 2. Documentation site.
out=$(render mkdocs -d docs_tool=mkdocs)
[ -f "$out/.github/workflows/deploy-docs.yaml" ] || fail "docs workflows missing with docs_tool=mkdocs"
check_tree "$out"
gate "$out" docs-test

# 3. No source skeleton: the project brings its own package.
out=$(render bare -d use_source_code_skeleton=false)
[ ! -e "$out/src" ] || fail "src rendered without the skeleton"
mkdir -p "$out/src/demo_pkg" "$out/tests"
printf '__version__ = "0.0.0"\n' > "$out/src/demo_pkg/_version.py"
printf 'from demo_pkg._version import __version__\n\n__all__ = ["__version__"]\n' > "$out/src/demo_pkg/__init__.py"
printf 'def main() -> int:\n    return 0\n' > "$out/src/demo_pkg/__cli__.py"
printf 'from demo_pkg import __version__\n\n\ndef test_version() -> None:\n    assert __version__\n' > "$out/tests/test_stub.py"
check_tree "$out"
gate "$out"

echo "render-test: all variants passed"
