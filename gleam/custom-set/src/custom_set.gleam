import gleam/list

pub opaque type Set(t) {
  Set(value: List(t))
}

pub fn new(members: List(t)) -> Set(t) {
  let unique_members = members |> list.unique
  Set(unique_members)
}

pub fn is_empty(set: Set(t)) -> Bool {
  set.value |> list.is_empty
}

pub fn contains(in set: Set(t), this member: t) -> Bool {
  set.value |> list.contains(member)
}

pub fn is_subset(first: Set(t), of second: Set(t)) -> Bool {
  let original_length = second.value |> list.length
  let new_length =
    second.value |> list.append(first.value) |> list.unique |> list.length
  new_length == original_length
}

pub fn disjoint(first: Set(t), second: Set(t)) -> Bool {
  let first_original_length = first.value |> list.length
  let second_original_length = second.value |> list.length
  let common_length =
    first.value |> list.append(second.value) |> list.unique |> list.length

  common_length == first_original_length + second_original_length
}

pub fn is_equal(first: Set(t), to second: Set(t)) -> Bool {
  first |> is_subset(second) && second |> is_subset(first)
}

pub fn add(to set: Set(t), this member: t) -> Set(t) {
  new([member, ..set.value])
}

pub fn intersection(of first: Set(t), and second: Set(t)) -> Set(t) {
  let new_members =
    first.value
    |> list.filter(fn(member) { second.value |> list.contains(member) })
  new(new_members)
}

pub fn difference(between first: Set(t), and second: Set(t)) -> Set(t) {
  let new_members =
    first.value
    |> list.filter(fn(m) { !{ second.value |> list.contains(m) } })
  new(new_members)
}

pub fn union(of first: Set(t), and second: Set(t)) -> Set(t) {
  let new_members =
    first.value
    |> list.append(second.value)
    |> list.unique
  new(new_members)
}
