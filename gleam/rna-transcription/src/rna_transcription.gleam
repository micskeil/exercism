import gleam/list
import gleam/result
import gleam/string

fn translate_nucleotides(dna: String) -> Result(String, Nil) {
  case dna {
    "G" -> Ok("C")
    "C" -> Ok("G")
    "T" -> Ok("A")
    "A" -> Ok("U")
    "" -> Ok("")
    _ -> Error(Nil)
  }
}

pub fn to_rna(dna: String) -> Result(String, Nil) {
  dna
  |> string.to_graphemes()
  |> list.try_map(translate_nucleotides)
  |> result.map(string.concat)
}
