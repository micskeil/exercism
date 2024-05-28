import gleam/list
import gleam/set.{type Set}
import gleam/string

fn create_ordered_word_list(word: String) -> List(String) {
  word
  |> string.lowercase
  |> string.to_graphemes
  |> list.sort(string.compare)
}

fn is_anagram(word: String, candidate: String) -> Bool {
  let word_list = create_ordered_word_list(word)
  let candidate_list = create_ordered_word_list(candidate)

  word_list == candidate_list && string.length(word) == string.length(candidate)
}

pub fn find_anagrams(word: String, candidates: List(String)) -> List(String) {
  case candidates {
    [] -> []
    [head, ..tail] -> {
      let is_anagram = is_anagram(word, head)
      let is_same_word = string.lowercase(word) == string.lowercase(head)

      case is_anagram, is_same_word {
        True, True -> find_anagrams(word, tail)
        False, _ -> find_anagrams(word, tail)
        True, False -> [head, ..find_anagrams(word, tail)]
      }
    }
  }
}
