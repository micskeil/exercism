import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import gleam/string

const chars_to_remove = [
  ",", ".", "\n", "\r", "\t", ":", ";", "!", "?", "(", ")", "[", "]", "{", "}",
  "\"", "“", "”", "‘", "’", "—", "-", "_", "…", "•", "•", "$",
  "%", "&", "#", "@", "^", "*", "+", "=", "<", ">", "/", "\\", "|", "`", "~",
]

const chars_to_remove_only_from_ends = ["'"]

const change_to_whitespace = ["\n", "\r", "\t", ","]

fn remove_unwanted_chars(word: String) -> String {
  let word =
    word
    |> string.trim()

  // remove unwanted chars from the start and end of the word
  let word =
    chars_to_remove_only_from_ends
    |> list.fold(word, fn(acc, char) {
      let starting_char = string.slice(acc, 0, 1)
      let ending_char = string.slice(acc, -1, 1)
      let acc = case starting_char == char {
        True -> string.drop_left(acc, 1)
        _ -> acc
      }
      let acc = case ending_char == char {
        True -> string.drop_right(acc, 1)
        _ -> acc
      }
      acc
    })

  chars_to_remove
  |> list.fold(word, fn(acc, char) { string.replace(acc, char, "") })
}

fn word_counter(
  acc: Dict(String, Int),
  words: List(String),
) -> Dict(String, Int) {
  case words {
    [] -> acc
    [word, ..] -> {
      let count = dict.get(acc, word) |> result.unwrap(0)
      word_counter(dict.insert(acc, word, count + 1), words |> list.drop(1))
    }
  }
}

pub fn count_words(input: String) -> Dict(String, Int) {
  let words =
    change_to_whitespace
    |> list.fold(input, fn(acc, char) { string.replace(acc, char, " ") })
    |> string.split(" ")
    |> list.map(fn(word) { string.lowercase(word) |> remove_unwanted_chars() })
    |> list.filter(fn(word) { word != "" })

  // put each word in the dict if it doesn't exist, increment the count if it does
  words
  |> word_counter(dict.new(), _)
}
