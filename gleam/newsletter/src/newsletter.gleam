import gleam/list
import gleam/result
import gleam/string
import simplifile

fn create_email_list(text: String) -> List(String) {
  string.split(text, "\n")
  |> list.filter(fn(x) { x != "" })
}

pub fn read_emails(path: String) -> Result(List(String), Nil) {
  let content = simplifile.read(path)

  case content {
    Ok(s) -> Ok(create_email_list(s))
    Error(_) -> Error(Nil)
  }
}

pub fn create_log_file(path: String) -> Result(Nil, Nil) {
  case simplifile.write(path, "") {
    Ok(_) -> Ok(Nil)
    Error(_) -> Error(Nil)
  }
}

pub fn log_sent_email(path: String, email: String) -> Result(Nil, Nil) {
  case simplifile.append(path, email <> "\n") {
    Ok(_) -> Ok(Nil)
    Error(_) -> Error(Nil)
  }
}

pub fn send_newsletter(
  emails_path: String,
  log_path: String,
  send_email: fn(String) -> Result(Nil, Nil),
) -> Result(Nil, Nil) {
  use _ <- result.try(create_log_file(log_path))
  use emails <- result.try(read_emails(emails_path))
  use email <- list.try_each(emails)
  case send_email(email) {
    Ok(_) -> log_sent_email(log_path, email)
    Error(_) -> Ok(Nil)
  }
}
