#include <cstdint>
#include <fstream>
#include <functional>
#include <iostream>
#include <numeric>
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
auto _find_x_positions(std::vector<std::string> const &game,
                       char const target = 'X')
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

/*! Given a canvas and a positions, it'll find all N-lenght words around. */
auto _find_local_words(std::vector<std::string> const &game,
                       std::pair<int, int> const &pos, uint32_t const w_lenght)
    -> std::vector<std::string> {
  auto result = std::vector<std::string>();

  auto [line_pos, chr_pos] = pos;
  std::string buff = game[line_pos].substr(chr_pos, 1);
  std::vector<std::pair<std::function<int(int)>, std::function<int(int)>>>
      actions = {
          // Top left.
          std::make_pair([](int lp) { return lp - 1; },
                         [](int cp) { return cp - 1; }),
          // Top.
          std::make_pair([](int lp) { return lp - 1; },
                         [](int cp) { return cp; }),
          // Top right.
          std::make_pair([](int lp) { return lp - 1; },
                         [](int cp) { return cp + 1; }),
          // Left.
          std::make_pair([](int lp) { return lp; },
                         [](int cp) { return cp - 1; }),
          // Right.
          std::make_pair([](int lp) { return lp; },
                         [](int cp) { return cp + 1; }),
          // Bottom left.
          std::make_pair([](int lp) { return lp + 1; },
                         [](int cp) { return cp - 1; }),
          // Bottom.
          std::make_pair([](int lp) { return lp + 1; },
                         [](int cp) { return cp; }),
          // Bottom right.
          std::make_pair([](int lp) { return lp + 1; },
                         [](int cp) { return cp + 1; }),
      };

  for (auto const &act : actions) {
    for (int i = 1; i < w_lenght; ++i) {
      line_pos = act.first(line_pos);
      chr_pos = act.second(chr_pos);

      if (line_pos < 0 || chr_pos < 0 || line_pos >= game.size() ||
          chr_pos >= game[0].size())
        break;

      buff.push_back(game[line_pos][chr_pos]);
    }

    if (buff.size() == w_lenght)
      result.push_back(buff);

    line_pos = pos.first;
    chr_pos = pos.second;
    buff = game[line_pos].substr(chr_pos, 1);
  }

  return result;
}

/*! Find each 'X' pos and generates a list of all words possible to filter. */
auto solve(std::string const input) -> int {
  auto const game = utils::str_split(input, "\n");
  auto const words_matrix = _find_x_positions(game) |
                            std::ranges::views::transform([&](auto const &pos) {
                              return _find_local_words(game, pos, 4);
                            });
  auto results = std::vector<std::string>();

  for (auto const &words : words_matrix)
    for (auto const &word : words)
      results.push_back(word);

  auto const filtered_results =
      results | std::ranges::views::filter([](auto const &word) {
        return word == "XMAS";
      }) |
      std::ranges::to<std::vector<std::string>>();

  return filtered_results.size();
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
