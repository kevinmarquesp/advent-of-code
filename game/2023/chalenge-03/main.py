#!/usr/bin/env python3

from enum import unique
from typing import Optional, Any
from sys import argv
from rich.console import Console

console = Console()

def get_line_numbers_index_list(line: str) -> list[tuple]:
    numbers_index = []

    current_number_indexes_buffer = []
    already_registered_count = 0

    for pos, char in enumerate(line):

        if char.isdigit():
            current_number_indexes_buffer.append(pos)
            already_registered_count += 1

        elif already_registered_count > 0:
            first_num = current_number_indexes_buffer[0]
            last_num = current_number_indexes_buffer[-1]

            current_number_indexes_buffer = []
            already_registered_count = 0

            numbers_index.append((first_num, last_num))

    if already_registered_count > 0:
        first_num = current_number_indexes_buffer[0]
        last_num = current_number_indexes_buffer[-1]

        numbers_index.append((first_num, last_num))

    return numbers_index


def get_line_inner_numbers_list(line: str) -> list[int]:
    numbers_index_list = get_line_numbers_index_list(line)
    numbers_list = []
    
    for number_index in numbers_index_list:
        start, end = number_index
        numbers_list.append(int(line[start: end + 1]))

    return numbers_list


def get_arround_symbols_bool_mask(line: Optional[str],
                                  nums_index_list: list[tuple]) -> list[bool]:
    symb_arround_mask = []

    for number_index_pair in nums_index_list:
        if line is None or len(line) < 1:
            break

        lpos, rpos = number_index_pair
        lchar = line[lpos - 1] if lpos - 1 >= 0 else None
        rchar = line[rpos + 1] if rpos + 1 < len(line) else None

        symb_arround_mask.append(('.' != rchar and rchar is not None) or
                                 ('.' != lchar and lchar is not None))

    return symb_arround_mask


def get_inner_symbols_bool_mask(line: Optional[str],
                                nums_index_list: list[tuple]) -> list[bool]:
    symb_inner_mask = []

    for number_index_pair in nums_index_list:
        if line is None or len(line) < 1:
            break

        lpos, rpos = number_index_pair
        str_slice = line[lpos: rpos + 1]

        symb_inner_mask.append(len(str_slice.replace('.', '')) > 0)

    return symb_inner_mask


def get_valid_numbers_for_each_line(pline: Optional[str], cline: str,
                                    nline: Optional[str]) -> list[int]:
    nums_index_list = get_line_numbers_index_list(cline)
    nums_list = get_line_inner_numbers_list(cline)

    prev_symb_arround_mask = get_arround_symbols_bool_mask(pline,
                                                           nums_index_list)
    curr_symb_arround_mask = get_arround_symbols_bool_mask(cline,
                                                           nums_index_list)
    next_symb_arround_mask = get_arround_symbols_bool_mask(nline,
                                                           nums_index_list)

    prev_symb_inner_mask = get_inner_symbols_bool_mask(pline, nums_index_list)
    next_symb_inner_mask = get_inner_symbols_bool_mask(nline, nums_index_list)

    console.log(f'"{cline}" [yellow]numbers positions    [/] {nums_index_list}')
    console.log(f'"{cline}" [yellow]inner numbers        [/] {nums_list}')
    console.log(f'"{cline}" [yellow]previous line        [/] "{pline}"')
    console.log(f'"{cline}" [yellow]next line            [/] "{nline}"')
    console.log(f'"{cline}" [yellow]previous arround mask[/] {prev_symb_arround_mask}')
    console.log(f'"{cline}" [yellow]current arround mask [/] {curr_symb_arround_mask}')
    console.log(f'"{cline}" [yellow]next arround mask    [/] {next_symb_arround_mask}')
    console.log(f'"{cline}" [yellow]previous inner mask  [/] {prev_symb_inner_mask}')
    console.log(f'"{cline}" [yellow]next inner mask      [/] {next_symb_inner_mask}')

    valid_index_list = []

    for match_cases in (prev_symb_arround_mask, curr_symb_arround_mask,
                       next_symb_arround_mask, prev_symb_inner_mask,
                       next_symb_inner_mask):
        console.log(f'[purple]debug[/] :: {match_cases}')

        for key, is_match in enumerate(match_cases):
            if is_match and key not in valid_index_list:
                valid_index_list.append(key)

    valid_numbers = [nums_list[index] for index in valid_index_list]

    console.log(f'[purple]debug[/] :: {valid_index_list}')
    console.log('[black]' + '-' * 120)

    return valid_numbers


def main(file_path: str) -> None:
    with open(file_path, 'r') as file_content:
        content_lines = [line.replace('\n', '')
                         for line in file_content.readlines()]

        length = len(content_lines)
        valid_numbers = []

        for key, cline in enumerate(content_lines):
            pline = content_lines[key - 1] if key > 0 else None
            nline = content_lines[key + 1] if key < length - 1 else None

            valid_numbers += get_valid_numbers_for_each_line(pline, cline,
                                                             nline)

        console.log(f'RESULT: {valid_numbers}')
        console.log(f'RESULT: {sum(valid_numbers)}')


if __name__ == '__main__':
    main(argv[1])
