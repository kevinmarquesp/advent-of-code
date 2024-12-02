#!/usr/bin/env python3

from sys import argv


def get_report_list(inp: str) -> list[list[int]]:
    """Converts the input/example into a matrix of reports and levels."""
    reports = [[int(num) for num in line.split()]
               for line in inp.strip().split("\n")]

    return reports


def is_report_valid(report: list[int]) -> bool:
    """Checks the order and the increasing/decreasing rate to validate."""
    mask = [report[key] - report[key + 1] for key in range(len(report) - 1)]
    el = len(report) - 1  # Expected lenght

    try:
        assert (len([1 for num in mask if num > 0]) == el or
                len([-1 for num in mask if num < 0]) == el), "Invalid order"

        for num in mask:
            assert abs(num) > 0, "The difference should be at least one"
            assert abs(num) <= 3, "The difference should be at most three"

        return True

    except Exception:
        return False


def solve(inp: str) -> int:
    """Returns the ammount of valid reports."""
    reports = get_report_list(inp)
    vals = [is_report_valid(report) for report in reports]

    return vals.count(True)


def main() -> None:
    """Boilerplate to read the input/example file from the arguments list."""
    if len(argv) < 2:
        raise Exception(
            "Invalid arguments list: Provide the problem input text file")

    file = argv[1]

    with open(file) as data:
        inp = data.read()
        res = solve(inp)

        print(res)


if __name__ == "__main__":
    main()
