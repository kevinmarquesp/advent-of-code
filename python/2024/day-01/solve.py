#!/usr/bin/env python3

from sys import argv


def separate_lists(inp: str) -> tuple[list[int], list[int]]:
    """Converts the two collumns into two sorted lists."""
    parsed = [[int(num) for num in line.split() if num.isnumeric()]
              for line in inp.strip().split("\n")]

    left = []
    right = []

    for pair in parsed:
        left.append(pair[0])
        right.append(pair[1])

    return sorted(left), sorted(right)


def solve(inp: str) -> int:
    """Sum the difference between each numer when the lists are sorted."""
    left, right = separate_lists(inp)

    assert len(left) == len(right), "Invalid input, column sizes doesn't match"

    comp = []

    for key in range(len(left)):
        diff = abs(left[key] - right[key])

        comp.append(diff)

    return sum(comp)


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
