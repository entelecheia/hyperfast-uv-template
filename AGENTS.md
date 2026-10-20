# hyperfast-uv-template

Copier template for Python packages managed with uv. `copier.yaml` holds the questions and `.copier-template/` is what a project receives. The root is also a rendered example package (`hyperfastuv`) whose workflows run for real on GitHub. It is not a library anyone imports.

## Commands

- Template gate: `make render-test` (renders three variants, removes `.git` from each, runs their `make install verify`, plus `make docs-test` for mkdocs)
- Root package: `make install`, `make verify`, `make docs-test`

## Verifying your work

Run both before reporting any change complete, and paste the tail of the output:

```bash
make render-test && make verify
```

Healthy output ends with `render-test: all variants passed` and then `N passed`. Both need no `.git` and no secrets.
When a check fails, fix the template, never the check.

## Conventions

- Edit workflows and `dependabot.yaml` under the root `.github/`. The files under `.copier-template/.github/` are symlinks to them; never replace a symlink with a copy, because Dependabot only updates the root.
- Workflows are plain YAML, not Jinja: projects receive them verbatim, so they must not depend on template answers. Conditional files go through `_exclude` in `copier.yaml`.
- Every question needs a default or a validator so `copier copy --defaults` works; `make render-test` runs that path.
- Root files (`pyproject.toml`, `Makefile`, `mkdocs.yaml`, `docs/`, `src/`, `tests/`, `REVIEW.md`) mirror what the template renders with `.copier-config.yaml`; update them in the same PR as the template change. `AGENTS.md`, `README.md`, `scripts/`, and `.github/workflows/template.yaml` are root only.
- Releases: conventional commits, cut by fast-forwarding `release` to `main`. Projects pin the tag in `.copier-config.yaml`, so a change that needs action in existing projects (removed or renamed question, new layout) carries a `BREAKING CHANGE` footer.
- Pins that move together: copier (`_min_copier_version`, `scripts/render-test.sh`, `template-update` in `Makefile.jinja`) and uv (workflows, `build_command` in `pyproject.toml.jinja`).

## Architecture

- `copier.yaml`: questions, `_tasks`, `_exclude`, `_skip_if_exists`.
- `.copier-template/`: files with a `.jinja` suffix are rendered, all others are copied verbatim.
- `scripts/render-test.sh`: the template gate.
- `.github/workflows/template.yaml`: runs the gate on pull requests.

## Things the agent gets wrong

- Add one dated line per repeated mistake: the mistake, the rule that prevents it, and when to revisit it.

---

Keep this file near one page: it is loaded in full every session. Directives only; rationale and history go to README.md.
When the same mistake appears twice, add the correction here in the same PR.
