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
    """Maps each appearence of the left in the right and sum the scores."""
    left, right = separate_lists(inp)

    assert len(left) == len(right), "Invalid input, column sizes doesn't match"

    acc = []

    for num in left:
        count = right.count(num)

        acc.append(num * count)

    return sum(acc)


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
