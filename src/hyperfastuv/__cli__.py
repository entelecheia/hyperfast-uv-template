"""Command line interface for Hyperfast UV Template."""

import argparse
from collections.abc import Sequence

from hyperfastuv._version import __version__


def main(argv: Sequence[str] | None = None) -> int:
    """Parse the command line and return the exit code."""
    parser = argparse.ArgumentParser(prog="hyperfastuv")
    parser.add_argument("--version", action="version", version=f"%(prog)s {__version__}")
    parser.parse_args(argv)
    parser.print_help()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
