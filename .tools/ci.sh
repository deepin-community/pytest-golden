#!/bin/sh
set -e

cd "$(dirname "$0")/.."

with_groups() {
    echo "::group::$@"
    "$@" && echo "::endgroup::"
}

"$@" autoflake -i -r --remove-all-unused-imports --remove-unused-variables pytest_golden tests
"$@" isort -q pytest_golden tests
"$@" black -q pytest_golden tests
"$@" pytest -q
python -c 'import sys, os; sys.exit((3,8) <= sys.version_info < (3,10) and os.name == "posix")' ||
"$@" pytype pytest_golden

PYTHONPATH=$(pwd)/example "$@" pytest -q example
