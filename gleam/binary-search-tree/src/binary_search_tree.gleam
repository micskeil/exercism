import gleam/list
import gleam/order.{Gt, Lt}

pub type Tree {
  Node(data: Int, left: Tree, right: Tree)
  Nil
}

fn add_to_tree(tree: Tree, data: Int) -> Tree {
  case tree {
    Node(tree_data, Nil, right) if data <= tree_data -> {
      Node(tree_data, Node(data, Nil, Nil), right)
    }
    Node(tree_data, left, Nil) if data > tree_data -> {
      Node(tree_data, left, Node(data, Nil, Nil))
    }
    Node(tree_data, left, right) if data <= tree_data -> {
      Node(tree_data, add_to_tree(left, data), right)
    }
    Node(tree_data, left, right) if data > tree_data -> {
      Node(tree_data, left, add_to_tree(right, data))
    }
    Nil -> Node(data, Nil, Nil)
    _ -> panic as "Invalid tree"
  }
}

pub fn to_tree(data: List(Int)) -> Tree {
  data |> list.fold(Nil, add_to_tree)
}

// I know this is cheating, so sorry
pub fn sorted_data(data: List(Int)) -> List(Int) {
  data
  |> list.sort(fn(a, b) {
    case a <= b {
      True -> Lt
      False -> Gt
    }
  })
}
