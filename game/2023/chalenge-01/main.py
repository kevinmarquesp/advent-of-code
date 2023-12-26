#!/usr/bin/env python3

INPUT_FILE = 'input.txt'

with open(INPUT_FILE, 'r') as file:
    lines = file.readlines()
    lines = list(map(lambda line: line.replace('\n', ''), lines))
    res_list = []

    for line in lines:
        nums_list = []

        for ckey, char in enumerate(line):
            if char.isnumeric():
                nums_list.append(int(char))

            for nkey, number in enumerate(['one', 'two', 'three', 'four',
                                           'five', 'six', 'seven', 'eight',
                                           'nine']):
                if line.startswith(number, ckey):
                    nums_list.append(nkey + 1)

        res_list.append(int(f'{nums_list[0]}{nums_list[-1]}'))

    print(sum(res_list))


