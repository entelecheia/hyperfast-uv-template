"""Hyperfast UV Template."""

from hyperfastuv._version import __version__

__all__ = ["__version__", "get_version"]


def get_version() -> str:
    """Return the package version."""
    return __version__
