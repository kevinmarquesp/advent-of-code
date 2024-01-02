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


# def get_line_inner_numbers_list(line: str) -> list[int]:
#     numbers_index_list = get_line_numbers_index_list(line)
#     numbers_list = []
#    
#     for number_index in numbers_index_list:
#         start, end = number_index
#         numbers_list.append(int(line[start: end + 1]))
#
#     return numbers_list


# def get_arround_symbols_bool_mask(line: Optional[str],
#                                   nums_index_list: list[tuple]) -> list[bool]:
#     symb_arround_mask = []
#
#     for number_index_pair in nums_index_list:
#         if line is None or len(line) < 1:
#             break
#
#         lpos, rpos = number_index_pair
#         lchar = line[lpos - 1] if lpos - 1 >= 0 else None
#         rchar = line[rpos + 1] if rpos + 1 < len(line) else None
#
#         symb_arround_mask.append(('.' != rchar and rchar is not None) or
#                                  ('.' != lchar and lchar is not None))
#
#     return symb_arround_mask


# def get_inner_symbols_bool_mask(line: Optional[str],
#                                 nums_index_list: list[tuple]) -> list[bool]:
#     symb_inner_mask = []
#
#     for number_index_pair in nums_index_list:
#         if line is None or len(line) < 1:
#             break
#
#         lpos, rpos = number_index_pair
#         str_slice = line[lpos: rpos + 1]
#
#         symb_inner_mask.append(len(str_slice.replace('.', '')) > 0)
#
#     return symb_inner_mask


def get_whole_numbers_on_this_positions(line: Optional[str], adjacent_nums_pos: tuple) -> list[int]:
    if line is None:
        return []

    numbers_index_list = get_line_numbers_index_list(line)
    whole_adjacent_numbers_positions = []

    for num_pos_pair in numbers_index_list:
        start, end = num_pos_pair
        each_pos_index = list(range(start, end + 1))

        for adjacent_num_pos in adjacent_nums_pos:
            if adjacent_num_pos in each_pos_index and num_pos_pair not in whole_adjacent_numbers_positions:
                whole_adjacent_numbers_positions.append(num_pos_pair)

    whole_adjacent_numbers = [int(line[start: end + 1]) for start, end in whole_adjacent_numbers_positions]

    return whole_adjacent_numbers


def get_adjacent_digit_characters_position(line: Optional[str], star_pos: int) -> tuple:
    if line is None:
        return (None, None, None)
    
    digit_positions = []

    for index in range(star_pos - 1, star_pos + 2):
        if index > 0 and index < len(line) and line[index].isdigit():
            digit_positions.append(index)
        else:
            digit_positions.append(None)

    return tuple(digit_positions)


def get_valid_numbers_for_each_line(pline: Optional[str], cline: str, nline: Optional[str]) -> list[int]:
    console.log(f'"{pline}"\n"{cline}" <-\n"{nline}"')

    star_char_index_list = []

    for key, char in enumerate(cline):
        if char == '*':
            star_char_index_list.append(key)

    adjacent_numbers_for_each_star = []

    for star_pos in star_char_index_list:
        prev_adjacent_numbers_positions = get_adjacent_digit_characters_position(pline, star_pos)
        curr_adjacent_numbers_positions = get_adjacent_digit_characters_position(cline, star_pos)
        next_adjacent_numbers_positions = get_adjacent_digit_characters_position(nline, star_pos)

        prev_adjacent_numbers = get_whole_numbers_on_this_positions(pline, prev_adjacent_numbers_positions)
        curr_adjacent_numbers = get_whole_numbers_on_this_positions(cline, curr_adjacent_numbers_positions)
        next_adjacent_numbers = get_whole_numbers_on_this_positions(nline, next_adjacent_numbers_positions)

        adjacent_numbers_for_each_star.append(prev_adjacent_numbers + curr_adjacent_numbers + next_adjacent_numbers)

    multiply_results = []

    for adjacent_numbers in adjacent_numbers_for_each_star:
        if len(adjacent_numbers) == 2:
            result = 1

            for num in adjacent_numbers:
                result = result * num

            multiply_results.append(result)

    console.log('[black]' + '-' * 120)
    return multiply_results


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
