#!/usr/bin/env python3

from sys import argv
from rich.console import Console

console: Console = Console()


EXPECTED_COLORS = [12, 13, 14]
valid_games_buff = []


def round_list_insert_non_specified(round_list: list[str]) -> list[str]:
    nonu_list = list(map(lambda e: e.split(' ')[0],
                         round_list))

    for color in ['red', 'green', 'blue']:
        if nonu_list.count(color) < 1:
            round_list.append(f'{color} 0')

    return round_list


## returns in the format [red, green, blue]
def get_balls_list_from_game_case(game_case: str) -> list[int]:
    round_list = list(map(lambda e: e.strip(), game_case.split(',')))
    round_list = list(map(lambda e: ' '.join(e.split(' ')[::-1]), round_list))
    round_list = round_list_insert_non_specified(round_list)

    return list(map(lambda e: int(e.split(' ')[1]),
                    sorted(round_list)[::-1]))


def run_for_each_game(game_id: int, game_str: str) -> None:
    is_curr_game_valid = True

    for game_round in game_str.split(';'):
        balls_list = get_balls_list_from_game_case(game_round.strip())

        for i in range(3):
            if balls_list[i] > EXPECTED_COLORS[i]:
                is_curr_game_valid = False

    if is_curr_game_valid:
        valid_games_buff.append(game_id)


def solution(data: list[str]) -> None:
    for game_index, game_str in enumerate(data):
        game_str = game_str.split(':')[1].strip()
        run_for_each_game(game_index + 1, game_str)

    print()  #display all results!
    console.log(f'[green]valid: {valid_games_buff}')
    console.log(f'[green]  sum: {sum(valid_games_buff)}\n')


def main(input: str) -> None:
    with open(input, 'r') as file:
        text_content: list[str] = list(map(lambda line: line.replace('\n', ''),
                                           file.readlines()))
        solution(text_content)


if __name__ == '__main__':
    main(argv[1])


# CODE GORE
# content: list[str] = _map(content,
#     lambda game: game.split(':')[1].strip())
# data_base: list[list[str]] = _map(content,
#     lambda game_info: _map(game_info.split(';'),
#         lambda info: info.strip()))
# data_mid: list[list[list[str]]] = _map(data_base,
#     lambda info_list: _map(info_list,
#         lambda info_str: info_str.split(',')))
# data_mid = _map(data_mid,
#     lambda game_list: _map(game_list,
#         lambda game_case: _map(game_case,
#             lambda case_info: ' '.join(case_info.split(' ')[::-1]))))
# for color in ['red', 'green', 'blue']:
#     data_mid = _map(data_mid,
#         lambda game_list: _map(game_list,
#             lambda game_case:
#                 game_case + [f'{color} 0'] if _find(game_case, color) < 0
#                                       else game_case))
# data_mid = _map(data_mid,
#     lambda game_list: _map(game_list,
#         lambda game_case: sorted(game_case)[::-1]))
# data_mid = _map(data_mid,
#     lambda game_list: _map(game_list,
#         lambda game_case: _map(game_case,
#             lambda case_info: _smap(case_info,
#                 lambda char: char if char.isdigit()
#                                   else ''))))
# data: list[list[int]] = _map(data_mid,
#     lambda game_list: _map(game_list,
#         lambda game_case: _map(game_case,
#             lambda case_info: int(case_info))))
