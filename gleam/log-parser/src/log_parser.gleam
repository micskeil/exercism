import gleam/option.{Some}
import gleam/regex.{Match}

pub fn is_valid_line(line: String) -> Bool {
  let assert Ok(r) = regex.from_string("^\\[(DEBUG|INFO|WARNING|ERROR)\\].*")
  regex.check(r, line)
}

pub fn split_line(line: String) -> List(String) {
  let assert Ok(re) = regex.from_string("<[~*=-]*>")
  regex.split(re, line)
}

pub fn tag_with_user_name(line: String) -> String {
  let assert Ok(r) = regex.from_string("User\\s+(\\S+)")
  case regex.scan(r, line) {
    [Match(_, [Some(name)])] -> "[USER] " <> name <> " " <> line
    _ -> line
  }
}
