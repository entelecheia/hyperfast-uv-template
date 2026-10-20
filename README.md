# Hyperfast UV Template

[![pypi-image]][pypi-url]
[![version-image]][release-url]
[![release-date-image]][release-url]
[![license-image]][license-url]

<!-- Links: -->
[pypi-image]: https://img.shields.io/pypi/v/hyperfast-uv-template
[pypi-url]: https://pypi.org/project/hyperfast-uv-template
[license-image]: https://img.shields.io/github/license/entelecheia/hyperfast-uv-template
[license-url]: https://github.com/entelecheia/hyperfast-uv-template/blob/main/LICENSE
[version-image]: https://img.shields.io/github/v/release/entelecheia/hyperfast-uv-template?sort=semver
[release-date-image]: https://img.shields.io/github/release-date/entelecheia/hyperfast-uv-template
[release-url]: https://github.com/entelecheia/hyperfast-uv-template/releases
[changelog]: https://github.com/entelecheia/hyperfast-uv-template/blob/main/CHANGELOG.md
[contributing guidelines]: https://github.com/entelecheia/hyperfast-uv-template/blob/main/CONTRIBUTING.md
<!-- Links: -->

A [Copier](https://copier.readthedocs.io/) template for Python packages managed with [uv](https://docs.astral.sh/uv/).

A generated project gets:

- `pyproject.toml` with hatchling, dependency groups (`test`, `lint`, optional `docs`), and a committed `uv.lock`
- one local gate, `make verify`: lock check, ruff check and format, mypy strict, pytest with coverage. It needs no `.git` and no secrets, so it also runs in a bare container
- GitHub Actions pinned by commit SHA: a PR gate on Python 3.11-3.15 with a single `ci-ok` check, releases with python-semantic-release and PyPI trusted publishing, and an optional Material for MkDocs site
- `AGENTS.md` and `REVIEW.md` for coding agents and reviewers

## Usage

Create a project (requires uv and git):

```bash
uvx copier@9.19.1 copy --trust gh:entelecheia/hyperfast-uv-template my-project
cd my-project
make install   # creates .venv and uv.lock; commit uv.lock
make verify
```

Update an existing project to the latest template release:

```bash
make template-update   # uvx copier update -a .copier-config.yaml --trust
```

The answers file is `.copier-config.yaml`, so plain `copier update` needs `-a .copier-config.yaml`.

To publish to PyPI, add a trusted publisher for the repository's `release.yaml` workflow on PyPI, then release by fast-forwarding the `release` branch to `main`.

## Changelog

See the [CHANGELOG] for more information.

## Contributing

Contributions are welcome! Please see the [contributing guidelines] for more information.

## License

This project is released under the [MIT License][license-url].
