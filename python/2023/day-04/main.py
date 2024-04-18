#!/usr/bin/env python3

## searched: https://stackoverflow.com/questions/33045222/how-do-you-alias-a-type-in-python#33045252
## searched: https://duckduckgo.com/?t=lm&q=python+typehints+lambda+function&ia=web

from dataclasses import dataclass
from sys import argv
from rich.console import Console
from typing import Callable, Any


class Debug:
    console: Console = Console()


    @staticmethod
    def print(log_str) -> None:
        Debug.console.print(log_str)


    @staticmethod
    def display_solution(log_str) -> None:
        Debug.console.print(f'SOLUTION 💡 {log_str}')


class Utils:
    @staticmethod
    def map(function: Callable[[Any], Any], array: list[Any]):
        return list(map(function, array))


    @staticmethod
    def filter(function: Callable[[Any], bool], array: list[Any]):
        return list(filter(function, array))


@dataclass
class ScratchCard:
    ID: int
    PLAYER_NUMS: list[int]
    WINNER_NUMS: list[int]
    ammount: int


class AdventOfCode:
    puzzle_input: list[str]
    SCRATCH_CARDS: list[ScratchCard]


    def __init__(self, puzzle_input: list[str]) -> None:
        self.puzzle_input = puzzle_input
        self.SCRATCH_CARDS = [self.__process_game_data_string(game_data_str)
                              for game_data_str in self.puzzle_input]


    def solve(self) -> int:
        for card in self.SCRATCH_CARDS:
            card_points = self.__get_card_points(card)
            copy_cards_ids = [poit_counter + card.ID
                              for poit_counter in range(1, card_points + 1)]

            for copy_card_id in copy_cards_ids * card.ammount:
                self.SCRATCH_CARDS[copy_card_id - 1].ammount += 1

        return sum(Utils.map(lambda card: card.ammount,
                             self.SCRATCH_CARDS))


    def __get_card_points(self, card: ScratchCard) -> int:
        counter = 0

        for player_num in card.PLAYER_NUMS:
            if player_num in card.WINNER_NUMS:
                counter += 1

        return counter


    def __process_game_data_string(self, game_data_str) -> ScratchCard:
        get_numbers_list = lambda nums_list_str: Utils.map(int, Utils.filter(lambda num_str: len(num_str) > 0,
                                                                             nums_list_str.split(' ')))

        comma_pos = game_data_str.index(':')
        right_data = game_data_str[comma_pos + 1:] #after the : character

        card_id = int(game_data_str[:comma_pos].split(' ')[-1])

        player_nums = get_numbers_list(right_data.split('|')[0])
        winner_nums = get_numbers_list(right_data.split('|')[1])

        return ScratchCard(ID=card_id, PLAYER_NUMS=player_nums, WINNER_NUMS=winner_nums, ammount=1)


def main(file_path: str) -> None:
    with open(file_path, 'r') as file:
        file_content = list(map(lambda line: line.replace('\n', ''),
                                file.readlines()))

        advent_of_code = AdventOfCode(file_content)
        solution = advent_of_code.solve()
        Debug.display_solution(solution)


if __name__ == '__main__':
    main(argv[1])
