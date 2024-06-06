import gleam/list

pub fn keep(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  list |> list.filter(predicate)
}

pub fn discard(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  list |> list.filter(fn(i) { !predicate(i) })
}
