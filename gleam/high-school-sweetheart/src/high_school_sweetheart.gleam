import gleam/io
import gleam/list
import gleam/string

pub fn first_letter(name: String) {
  let letter =
    string.trim(name)
    |> string.first
  case letter {
    Ok(l) -> l
    _ -> ""
  }
}

pub fn initial(name: String) {
  let first_letter =
    first_letter(name)
    |> string.uppercase
  string.concat([first_letter, "."])
}

pub fn initials(full_name: String) {
  full_name
  |> string.split(" ")
  |> list.map(initial)
  |> string.join(" ")
}

pub fn pair(full_name1: String, full_name2: String) {
  let heart_template =
    "
     ******       ******
   **      **   **      **
 **         ** **         **
**            *            **
**                         **
**     F. X.  +  L. X.     **
 **                       **
   **                   **
     **               **
       **           **
         **       **
           **   **
             ***
              *
"
  string.replace(heart_template, "F. X.", initials(full_name1))
  |> string.replace("L. X.", initials(full_name2))
}
