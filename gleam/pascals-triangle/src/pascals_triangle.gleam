import gleam/list
import gleam/result

// calculate the pascal's triangle up to the nth row
pub fn rows(n: Int) -> List(List(Int)) {
  generate_pascals_triangle(#(n, 0), [])
  |> list.reverse
}

fn generate_pascals_triangle(
  rows: #(Int, Int),
  acc: List(List(Int)),
) -> List(List(Int)) {
  let #(total_rows, current_row) = rows
  let remaining_rows = total_rows - current_row

  case remaining_rows {
    0 -> acc
    _ -> {
      let next_row =
        next_row(
          acc
          |> list.first
          |> result.unwrap([]),
        )
      let acc = [next_row, ..acc]
      generate_pascals_triangle(#(total_rows, current_row + 1), acc)
    }
  }
}

///Calculates the next row of the pascal's triangle
fn next_row(current_row: List(Int)) -> List(Int) {
  case current_row {
    [] -> [1]
    [1] -> [1, 1]
    _ ->
      list.concat([
        [1],
        current_row
          |> list.window(2)
          |> list.map(fn(a) {
          a
          |> list.fold(0, fn(acc, x) { x + acc })
        }),
        [1],
      ])
  }
}
