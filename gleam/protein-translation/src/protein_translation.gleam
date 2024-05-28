import gleam/list
import gleam/result
import gleam/string

fn get_polypeptide(codon: String) -> Result(String, Nil) {
  case codon {
    "AUG" -> Ok("Methionine")
    "UUU" | "UUC" -> Ok("Phenylalanine")
    "UUA" | "UUG" -> Ok("Leucine")
    "UCU" | "UCC" | "UCA" | "UCG" -> Ok("Serine")
    "UAU" | "UAC" -> Ok("Tyrosine")
    "UGU" | "UGC" -> Ok("Cysteine")
    "UGG" -> Ok("Tryptophan")
    "UAA" | "UAG" | "UGA" -> Ok("STOP")
    _ -> Error(Nil)
  }
}

pub fn proteins(rna: String) -> Result(List(String), Nil) {
  rna
  |> string.to_graphemes()
  |> list.sized_chunk(into: 3)
  |> list.map(string.concat)
  |> list.map(get_polypeptide)
  |> list.take_while(fn(maybe_codon) { maybe_codon != Ok("STOP") })
  |> result.all()
}
