import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub type Forth {
  Forth(
    stack: List(Int),
    definitions: Dict(String, fn(Forth) -> Result(Forth, ForthError)),
  )
}

pub type ForthError {
  DivisionByZero
  StackUnderflow
  InvalidWord
  UnknownWord
}

fn add(forth: Forth) -> Result(Forth, ForthError) {
  case forth.stack {
    [] | [_] -> Error(StackUnderflow)
    [a, b, ..rest] -> {
      let sum = a + b
      Ok(Forth([sum, ..rest], forth.definitions))
    }
  }
}

fn sub(forth: Forth) -> Result(Forth, ForthError) {
  case forth.stack {
    [] | [_] -> Error(StackUnderflow)
    [a, b, ..rest] -> {
      let diff = b - a
      Ok(Forth([diff, ..rest], forth.definitions))
    }
  }
}

fn mul(forth: Forth) -> Result(Forth, ForthError) {
  case forth.stack {
    [] | [_] -> Error(StackUnderflow)
    [a, b, ..rest] -> {
      let product = a * b
      Ok(Forth([product, ..rest], forth.definitions))
    }
  }
}

fn div(forth: Forth) -> Result(Forth, ForthError) {
  case forth.stack {
    [] | [_] -> Error(StackUnderflow)
    [0, ..] -> Error(DivisionByZero)
    [a, b, ..rest] -> {
      let quotient = b / a
      Ok(Forth([quotient, ..rest], forth.definitions))
    }
  }
}

fn dup(forth: Forth) -> Result(Forth, ForthError) {
  case forth.stack {
    [] -> Error(StackUnderflow)
    [x, ..rest] -> Ok(Forth([x, x, ..rest], forth.definitions))
  }
}

fn drop(forth: Forth) -> Result(Forth, ForthError) {
  case forth.stack {
    [] -> Error(StackUnderflow)
    [_] -> Ok(Forth([], forth.definitions))
    [_, ..rest] -> Ok(Forth(rest, forth.definitions))
  }
}

fn swap(forth: Forth) -> Result(Forth, ForthError) {
  case forth.stack {
    [] | [_] -> Error(StackUnderflow)
    [a, b, ..rest] -> Ok(Forth([b, a, ..rest], forth.definitions))
  }
}

fn over(forth: Forth) -> Result(Forth, ForthError) {
  case forth.stack {
    [] | [_] -> Error(StackUnderflow)
    [a, b, ..rest] -> Ok(Forth([b, a, b, ..rest], forth.definitions))
  }
}

pub fn new() -> Forth {
  let base_definitions =
    dict.from_list([
      #("+", add),
      #("-", sub),
      #("*", mul),
      #("/", div),
      #("dup", dup),
      #("drop", drop),
      #("swap", swap),
      #("over", over),
    ])
  Forth([], base_definitions)
}

fn create_formated_stack(s: List(Int)) -> String {
  //return the stack as a string each value concated after each other
  s
  |> list.reverse
  |> list.fold("", fn(acc: String, x) {
    case string.length(acc) > 0 {
      True -> acc <> " " <> int.to_string(x)
      False -> int.to_string(x)
    }
  })
}

pub fn format_stack(f: Forth) -> String {
  //return the stack as a string each value concated after each other
  case f.stack {
    [] -> ""
    s -> create_formated_stack(s)
  }
}

fn eval_word(forth: Forth, word: String) -> Result(Forth, ForthError) {
  let function = dict.get(forth.definitions, word)

  case function {
    Ok(f) -> f(forth)
    Error(_) -> Error(UnknownWord)
  }
}

fn add_new_word_to_forth(f: Forth, word: String, progs: List(String)) -> Forth {
  let progs =
    progs
    |> list.map(fn(x) {
      let is_word_exists = dict.get(f.definitions, x)
      case is_word_exists {
        Ok(definition) -> {
          // get the value the original would return on an emty stack
          let forth = definition(Forth([], f.definitions))
          case forth {
            Ok(f) -> format_stack(f)
            Error(_) -> x
          }
        }
        Error(_) ->
          x
          |> string.lowercase
      }
    })

  let new_definitions =
    dict.insert(
      f.definitions,
      word
        |> string.lowercase,
      fn(f) { parse_progs(f, progs) },
    )
  Forth(f.stack, new_definitions)
}

fn define_word(f: Forth, progs: List(String)) -> Result(Forth, ForthError) {
  // parse the word and the definition
  case progs {
    [word, ..rest] -> {
      let is_number = int.parse(word)
      case is_number {
        Ok(_) -> Error(InvalidWord)
        Error(_) ->
          Ok(add_new_word_to_forth(
            f,
            word
              |> string.lowercase,
            rest
              |> list.filter(fn(x) { x != ";" }),
          ))
      }
    }
    _ -> Error(InvalidWord)
  }
}

fn eval_prog(f: Forth, command: String) -> Result(Forth, ForthError) {
  // check if it is a number 
  let is_number = int.parse(command)
  case is_number, command {
    Ok(n), _ -> Ok(Forth([n, ..f.stack], f.definitions))
    Error(_), _ -> eval_word(f, command)
  }
}

fn parse_progs(f: Forth, progs: List(String)) -> Result(Forth, ForthError) {
  case progs {
    [] -> Ok(f)
    [prog, ..rest] if prog == ":" -> {
      define_word(f, rest)
    }
    [prog, ..rest] -> {
      use forth <- result.try(eval_prog(f, prog))
      parse_progs(forth, rest)
    }
  }
}

pub fn eval(f: Forth, prog: String) -> Result(Forth, ForthError) {
  let progs =
    string.split(prog, " ")
    |> list.map(fn(x) { string.lowercase(x) })
  use forth <- result.try(parse_progs(f, progs))

  Ok(forth)
}
