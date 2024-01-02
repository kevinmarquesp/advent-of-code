#!/usr/bin/env python3

## searched: https://stackoverflow.com/questions/33045222/how-do-you-alias-a-type-in-python#33045252
## searched: https://duckduckgo.com/?t=lm&q=python+typehints+lambda+function&ia=web

from collections.abc import Callable
from sys import argv
from typing import Any
from rich.console import Console

console = Console()
log = console.log

ScratchCard = tuple[list[int], list[int]]


class Utils:
    @staticmethod
    def map(function: Callable[[Any], Any], array: list[Any]):
        return list(map(function, array))

    @staticmethod
    def filter(function: Callable[[Any], bool], array: list[Any]):
        return list(filter(function, array))


def process_card_info(card_str_info: str) -> ScratchCard:
    filtered_card_str_info = card_str_info[card_str_info.index(':') + 1:]  #remove the unwanted card number information

    card_str_info_data = Utils.map(lambda str_nums: str_nums.strip(),
                                   filtered_card_str_info.split('|'))
    player_numbers_str = Utils.filter(lambda str_num: len(str_num) > 0,
                                      [str_num for str_num in card_str_info_data[0].split(' ')])
    winner_numbers_str = Utils.filter(lambda str_num: len(str_num) > 0,
                                      [str_num for str_num in card_str_info_data[1].split(' ')])

    return (Utils.map(int, player_numbers_str), Utils.map(int, winner_numbers_str))


def calculate_total_card_points(winners_count: int) -> int:
    if winners_count <= 0:
        return 0

    total_points = 1

    for _ in range(1, winners_count):
        total_points *= 2

    return total_points


def execute_for_each_card_game(card: ScratchCard) -> int:  #note: *1
    player_nums, winner_nums = card
    valid_winners_count = 0
    total_points = 0

    for p_num in player_nums:
        if p_num in winner_nums:
            valid_winners_count += 1

    total_points = calculate_total_card_points(valid_winners_count)

    return total_points


def solve_puzzle(cards_info_list: list[str]) -> None:
    cards_list = [process_card_info(card_info) for card_info in cards_info_list]
    total_points = 0

    for card in cards_list:  #note(1): maybe it should has the keys also
        game_total_points = execute_for_each_card_game(card)
        total_points += game_total_points

    log(total_points)


def main(file_path: str) -> None:
    with open(file_path, 'r') as file:
        file_content = list(map(lambda line: line.replace('\n', ''),
                                file.readlines()))
        solve_puzzle(file_content)

if __name__ == '__main__':
    main(argv[1])
