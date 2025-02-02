"""Command line interface for the Hyperfast UV Template package.

This module provides the command-line interface for the package, allowing users
to interact with the package functionality through the terminal.

Example:
    To use the CLI, run the package with optional arguments:

    ```bash
    $ python -m hyperfastuv --name Alice --count 2
    Hello, Alice!
    This is hyperfastuv version 0.1.0.
    Hello, Alice!
    This is hyperfastuv version 0.1.0.
    ```
"""

import click

from hyperfastuv._version import __version__


@click.command()
@click.version_option(__version__)
@click.option("--count", "-c", default=1, help="Number of greetings.")
@click.option("--name", "-n", prompt="Your name", help="The person to greet.")
def main(count, name):
    """Run the main CLI function.

    This function serves as the entry point for the command-line interface.
    It prints a greeting message to the user a specified number of times.

    Args:
        count: Number of times to print the greeting message
        name: Name of the person to greet

    Example:
        >>> main(count=2, name='Alice')
        Hello, Alice!
        This is hyperfastuv version 0.1.0.
        Hello, Alice!
        This is hyperfastuv version 0.1.0.
    """
    # Print a message to the user.
    for _ in range(count):
        click.echo(f"Hello, {name}!")
        click.echo(f"This is hyperfastuv version {__version__}.")


# main function for the main module
if __name__ == "__main__":
    main()
