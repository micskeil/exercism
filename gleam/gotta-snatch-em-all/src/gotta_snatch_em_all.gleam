import gleam/list
import gleam/set.{type Set}
import gleam/string

pub fn new_collection(card: String) -> Set(String) {
  set.from_list([card])
}

pub fn add_card(collection: Set(String), card: String) -> #(Bool, Set(String)) {
  #(set.contains(collection, card), set.insert(collection, card))
}

pub fn trade_card(
  my_card: String,
  their_card: String,
  collection: Set(String),
) -> #(Bool, Set(String)) {
  let is_card_available = set.contains(collection, my_card)
  let is_card_needed = !set.contains(collection, their_card)

  let new_collection =
    set.delete(collection, my_card)
    |> set.insert(their_card)

  case is_card_available, is_card_needed {
    i, j if i && j -> {
      #(True, new_collection)
    }
    i, j if !i && j -> {
      #(False, new_collection)
    }
    _, _ -> {
      #(False, new_collection)
    }
  }
}

pub fn boring_cards(collections: List(Set(String))) -> List(String) {
  let boring_cards =
    list.reduce(collections, fn(acc, collection) {
      set.intersection(collection, acc)
    })
  case boring_cards {
    Error(Nil) -> []
    Ok(boring_cards) -> set.to_list(boring_cards)
  }
}

pub fn total_cards(collections: List(Set(String))) -> Int {
  let all_unique_cards =
    list.reduce(collections, fn(acc, collection) { set.union(collection, acc) })
  case all_unique_cards {
    Error(Nil) -> 0
    Ok(all_unique_cards) -> set.size(all_unique_cards)
  }
}

pub fn shiny_cards(collection: Set(String)) -> Set(String) {
  set.filter(collection, fn(card) { string.starts_with(card, "Shiny") })
}
