import gleam/list
import gleam/set
import gleam/string

// Check if the provided sentence is a pangram.
pub fn is_pangram(sentence: String) -> Bool {
  let alphabet =
    "abcdefghijklmnopqrstuvwxyz"
    |> string.to_graphemes
    |> set.from_list
  let sentence_graphemes =
    sentence
    |> string.to_graphemes
    |> list.map(string.lowercase)
    |> set.from_list

  alphabet == set.intersection(alphabet, sentence_graphemes)
}
