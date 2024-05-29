import gleam/list.{Continue, Stop}
import gleam/result
import gleam/string

pub fn slices(input: String, size: Int) -> Result(List(String), Error) {
  let input_len = string.length(input)
  case size {
    _ if input_len == 0 -> Error(EmptySeries)
    n if n > input_len -> Error(SliceLengthTooLarge)
    n if n < 0 -> Error(SliceLengthNegative)
    0 -> Error(SliceLengthZero)
    _ -> Ok(get_slices(input, size))
  }
}

fn get_slices(input: String, size: Int) -> List(String) {
  input
  |> string.to_graphemes
  |> list.window(size)
  |> list.map(string.concat)
}

pub type Error {
  EmptySeries
  SliceLengthNegative
  SliceLengthZero
  SliceLengthTooLarge
}
