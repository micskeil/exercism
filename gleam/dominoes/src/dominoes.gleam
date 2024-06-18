import gleam/list

pub fn can_chain(chain: List(#(Int, Int))) -> Bool {
  case chain {
    [] -> True
    [#(left_side, right_side)] if left_side == right_side -> True
    [_] -> False
    [_, ..unmatched] -> list.any(unmatched, find_matches(_, chain))
  }
}

// A chain of dominoes that looks like [a, ...], ..., [..., b] is equivalent to a single domino [a, b].
// Rather than keep track of the full chain, replace two matching dominoes with an equivalent single domino
fn find_matches(d: #(Int, Int), dominoes: List(#(Int, Int))) -> Bool {
  let assert [#(left_side, right_side), ..unmatched] = dominoes
  case d {
    #(left, right) as match | #(right, left) as match if right == left_side -> {
      let assert Ok(#(_, remaining)) = list.pop(unmatched, fn(m) { m == match })
      can_chain([#(right_side, left), ..remaining])
    }
    _ -> False
  }
}
