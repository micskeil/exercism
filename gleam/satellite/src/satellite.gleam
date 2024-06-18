import gleam/bool
import gleam/list
import gleam/result
import gleam/set

pub type Tree(a) {
  Nil
  Node(value: a, left: Tree(a), right: Tree(a))
}

pub type Error {
  DifferentLengths
  DifferentItems
  NonUniqueItems
}

fn safety_check(
  inorder inorder: List(a),
  preorder preorder: List(a),
) -> Result(Tree(a), Error) {
  use <- bool.guard(
    list.length(inorder) != list.length(preorder),
    Error(DifferentLengths),
  )
  let set_inorder = set.from_list(inorder)
  use <- bool.guard(
    set.size(set_inorder) != list.length(inorder),
    Error(NonUniqueItems),
  )
  let set_preorder = set.from_list(preorder)
  use <- bool.guard(set_inorder != set_preorder, Error(DifferentItems))
  Ok(Nil)
}

pub fn tree_from_traversals(
  inorder inorder: List(a),
  preorder preorder: List(a),
) -> Result(Tree(a), Error) {
  use _ <- result.try(safety_check(inorder, preorder))
  case preorder {
    [] -> Ok(Nil)
    [x, ..xs] -> {
      let assert #(left, [current, ..right]) =
        list.split_while(inorder, fn(elem) { elem != x })
      let assert Ok(lefttree) =
        tree_from_traversals(left, list.take(xs, list.length(left)))
      let assert Ok(righttree) =
        tree_from_traversals(right, list.drop(xs, list.length(left)))
      Ok(Node(current, lefttree, righttree))
    }
  }
}
