"""Hyperfast UV Template Package.

Example:
    >>> from hyperfastuv import get_version
    >>> version = get_version()
    >>> print(version)
    '0.1.0'
"""

from hyperfastuv._version import __version__


def get_version() -> str:
    """Get the version of the package.

    This function returns the current version of the package. It's useful for
    programmatically checking the version in your code or displaying it to users.

    Returns:
        str: The version of the package in semantic versioning format (e.g., "0.1.0")

    Example:
        >>> from hyperfastuv import get_version
        >>> version = get_version()
        >>> print(version)
        '0.1.0'
    """
    return __version__
