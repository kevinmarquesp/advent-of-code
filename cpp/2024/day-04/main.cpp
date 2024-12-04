#include <fstream>
#include <iostream>
#include <ostream>
#include <ranges>
#include <regex>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

/*! Utility functions to handle the string input, because C++ is quite hard. */
namespace utils {
/*! Returns a strings vector, separated by a custom delimeter. */
auto str_split(std::string str, std::string const sep)
    -> std::vector<std::string> {
  std::string const esc_sep =
      std::regex_replace(sep, std::regex(R"([.^$|()\\*+?{}])"), R"(\\$&)");
  std::regex const repeated_seps(esc_sep + "+");

  // Trim the repeated separators on a single sequency to just one.
  str = std::regex_replace(str, repeated_seps, sep);

  std::vector<std::string> result;

  size_t start = 0;
  size_t end;

  while ((end = str.find(sep, start)) != std::string::npos) {
    auto const slice = str.substr(start, end - start);
    start = end + 1;

    result.push_back(slice);
  }

  result.push_back(str.substr(start));

  // WARN: It will filter the empty values when outputing!
  return result | std::ranges::views::filter([](auto const &item) {
           return item.size() > 0;
         }) |
         std::ranges::to<std::vector>();
}

/*! Splits a string into only two slices, returning a std::pair type. */
auto str_pair(std::string str, std::string const sep)
    -> std::pair<std::string, std::string> {
  std::string const esc_sep =
      std::regex_replace(sep, std::regex(R"([.^$|()\\*+?{}])"), R"(\\$&)");
  std::regex const repeated_seps(esc_sep + "+");

  // Trim the repeated separators on a single sequency to just one.
  str = std::regex_replace(str, repeated_seps, sep);

  std::string left = "", right = "";
  size_t const pos = str.find(sep);

  if (pos != std::string::npos) {
    left = str.substr(0, pos);
    right = str.substr(pos + 1, str.size());
  }

  return std::pair<std::string, std::string>(left, right);
}

/*! Uses regex to search 'n match, returning a verctor of strings for that. */
auto str_findall(std::string str, std::regex const exp)
    -> std::vector<std::string> {
  auto res = std::vector<std::string>();
  auto begin = std::sregex_iterator(str.begin(), str.end(), exp);
  auto const end = std::sregex_iterator();

  for (auto &it = begin; it != end; ++it) {
    res.push_back(it->str());
  }

  return res;
}
} // namespace utils

/*! Returns a vector of pairs (line and char pos) given a canvas and a char. */
auto _find_a_positions(std::vector<std::string> const &game,
                       char const target = 'A')
    -> std::vector<std::pair<int, int>> {
  auto x_positions = std::vector<std::pair<int, int>>();

  for (auto const &[line_idx, line] : game | std::views::enumerate) {
    for (auto const &[chr_idx, chr] : line | std::views::enumerate) {
      if (chr != target)
        continue;

      x_positions.push_back(std::make_pair(line_idx, chr_idx));
    }
  }

  return x_positions;
}

/*! Given a canvas and a positions vec, check the corners looking for a MAS. */
auto _is_pos_mas(std::vector<std::string> const &game,
                 std::pair<int, int> const &position) -> bool {
  auto [line_pos, chr_pos] = position;

  if (line_pos - 1 < 0 || line_pos + 1 >= game.size() || chr_pos - 1 < 0 ||
      chr_pos + 1 >= game[0].size())
    return false;

  int mas_count = 0;

  if ((game[line_pos - 1][chr_pos - 1] == 'M' &&
       game[line_pos + 1][chr_pos + 1] == 'S') ||
      (game[line_pos - 1][chr_pos - 1] == 'S' &&
       game[line_pos + 1][chr_pos + 1] == 'M'))
    mas_count++;
  if ((game[line_pos - 1][chr_pos + 1] == 'M' &&
       game[line_pos + 1][chr_pos - 1] == 'S') ||
      (game[line_pos - 1][chr_pos + 1] == 'S' &&
       game[line_pos + 1][chr_pos - 1] == 'M'))
    mas_count++;

  return mas_count >= 2;
}

/*! Find each 'A' pos to validate them all, them filter the valids and count. */
auto solve(std::string const input) -> int {
  auto const game = utils::str_split(input, "\n");

  return (_find_a_positions(game) |
          std::ranges::views::transform(
              [game](auto const &pos) { return _is_pos_mas(game, pos); }) |
          std::ranges::views::filter([](auto const &res) { return res; }) |
          std::ranges::to<std::vector<bool>>())
      .size();
}

/*! Boilerplate to open the input file path given in the CLI argumetns. */
int main(int const argc, char *const argv[]) {
  if (argc != 2) {
    std::cout << "Invalid argument: Provide just one text file as input"
              << std::endl;
    return 1;
  }

  auto const input_path = argv[1];
  std::ifstream input_file(input_path);

  if (!input_file.is_open()) {
    std::cout << "File opening error: Can't open the specified path"
              << std::endl;
    return 1;
  }

  std::ostringstream input_buf;
  input_buf << input_file.rdbuf();

  input_file.close();

  auto const input = input_buf.str();
  auto const result = solve(input);

  std::cout << result << std::endl;

  return 0;
}
