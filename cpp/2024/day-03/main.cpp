#include <algorithm>
#include <fstream>
#include <iostream>
#include <iterator>
#include <numeric>
#include <ostream>
#include <ranges>
#include <regex>
#include <sstream>
#include <string>
#include <tuple>
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

/*! Executes the multiplication instruction string. */
auto _run_inst(std::string const &str) -> int {
  // Starts by filtering the "mul(" and the ")" at the end.
  auto const filtered = str.substr(4, str.find(")") - 4);
  auto const [s_left, s_right] = utils::str_pair(filtered, ",");

  auto const left = std::stoi(s_left);
  auto const right = std::stoi(s_right);

  return left * right;
}

/*! Find each instruction with regex and then accumulate the results. */
auto solve(std::string const input) -> int {
  auto instructions =
      utils::str_findall(input, std::regex(R"(mul\([0-9]+,[0-9]+\))"));

  auto results =
      instructions | std::ranges::views::transform(
                         [](auto const &inst) { return _run_inst(inst); });

  return std::accumulate(results.begin(), results.end(), 0);
}

/*! Boilerplate to open the input file path given in the CLI argumetns. */
int main(int argc, char *argv[]) {
  if (argc != 2) {
    std::cout << "Invalid argument: Provide just one text file as input"
              << std::endl;
    return 1;
  }

  auto input_path = argv[1];
  std::ifstream input_file(input_path);

  if (!input_file.is_open()) {
    std::cout << "File opening error: Can't open the specified path"
              << std::endl;
    return 1;
  }

  std::ostringstream input_buf;
  input_buf << input_file.rdbuf();

  input_file.close();

  auto input = input_buf.str();
  auto result = solve(input);

  std::cout << result << std::endl;

  return 0;
}
