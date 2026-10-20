# Review instructions

Read by every reviewer of a pull request, human or agent.

## Passes

Tag every finding with its pass:

- Bugs: logic errors, broken edge cases, regressions.
- Security: shell or `eval` use, secrets reaching logs or artifacts, workflow permissions wider than the job needs.
- Compliance: the change matches its issue (the spec). Workflow changes keep `timeout-minutes` on every job, cancel superseded PR runs, and pin actions by SHA.
- Instruction prose (AGENTS.md, REVIEW.md): each directive names the failure it prevents; rationale belongs in README.md. Nits unless behavior changes.

## Findings

Each finding carries its pass, severity, evidence (`file:line` or a reproduction), and provenance: introduced by this change, pre-existing, or indeterminate. Pre-existing findings go to a follow-up issue instead of widening the change. Report what was reviewed and what was not reached.

## What Important means here

Important: a bug, a security issue, a weakened gate, or a change to the public API or CLI without a spec line. Style and naming are nits.

## Cap the nits

Report at most 5 nits per review; summarize the rest as a count.

## Do not report

- Generated files: `uv.lock` (unless it changes without a matching `pyproject.toml` change), `CHANGELOG.md`, `src/hyperfastuv/_version.py`.
- Anything `make verify` already enforces.

## Feedback into AGENTS.md

When the same finding appears twice, add the rule to AGENTS.md in the same PR.
