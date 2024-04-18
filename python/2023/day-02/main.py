#!/usr/bin/env python3

from sys import argv
from rich.console import Console

console: Console = Console()


EXPECTED_COLORS = [12, 13, 14]
curr_minimum_balls_list = [0, 0, 0]
minimum_game_balls_result_list = []


def get_power(balls_list: list[int]) -> int:
    result = balls_list[0]
    for i in range(1, 3):
        result *= balls_list[i]
    return result


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
    for game_round in game_str.split(';'):
        balls_list = get_balls_list_from_game_case(game_round.strip())

        for i in range(3):
            if balls_list[i] > curr_minimum_balls_list[i]:
                curr_minimum_balls_list[i] = balls_list[i]

    minimum_game_balls_result_list.append(get_power(curr_minimum_balls_list))

    for i in range(3):
        curr_minimum_balls_list[i] = 0


def solution(data: list[str]) -> None:
    for game_index, game_str in enumerate(data):
        game_str = game_str.split(':')[1].strip()
        run_for_each_game(game_index + 1, game_str)

    print()  #display all results!
    console.log(f'[green]valid: {minimum_game_balls_result_list}')
    console.log(f'[green]  sum: {sum(minimum_game_balls_result_list)}\n')


def main(input: str) -> None:
    with open(input, 'r') as file:
        text_content: list[str] = list(map(lambda line: line.replace('\n', ''),
                                           file.readlines()))
        solution(text_content)


if __name__ == '__main__':
    main(argv[1])
