import gleam/list
import gleam/set
import gleam/string

const alphabet = [
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
  "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
]

pub fn is_isogram(phrase phrase: String) -> Bool {
  let letters_used =
    phrase
    |> string.lowercase
    |> string.to_graphemes
    |> list.filter(fn(x) { list.contains(alphabet, x) })

  // create a set from the list of letters used
  let phrase_set = set.from_list(letters_used)

  // compare the set of letters used to the list of letters used
  phrase_set |> set.size == letters_used |> list.length
}
