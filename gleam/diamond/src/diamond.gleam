import gleam/bool
import gleam/int
import gleam/io
import gleam/list.{Continue, Stop}
import gleam/string

const alphabet = [
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
  "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
]

fn create_line(acc, i, l, line_length) {
  let current_acc_lenght = string.length(acc)
  let is_letter_the_next_char =
    current_acc_lenght == i || current_acc_lenght == line_length - i - 1
  let is_last_letter = current_acc_lenght == line_length - 1

  let acc =
    acc
    <> case is_letter_the_next_char {
      True -> l
      False -> " "
    }

  case is_last_letter {
    True -> acc
    False -> create_line(acc, i, l, line_length)
  }
}

pub fn build(letter: String) -> String {
  let used_alphabet =
    alphabet
    |> list.fold_until([], fn(acc, l) {
      let acc = [l, ..acc]
      case l == letter {
        True -> Stop(acc)
        False -> Continue(acc)
      }
    })

  let line_length = 2 * { list.length(used_alphabet) - 1 } + 1

  let bottom_part =
    used_alphabet
    |> list.index_map(fn(l, i) { create_line("", i, l, line_length) })
  let top_part = bottom_part |> list.drop(1)

  list.append(top_part, bottom_part) |> string.join("\n")
}
