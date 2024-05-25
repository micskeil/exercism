//// Each log line is a string formatted as follows: "[<LEVEL>]: <MESSAGE>".
//// There are three different log levels: INFO, WARNING, ERROR.

import gleam/string

/// Returns the message from a log line
pub fn message(log_line: String) -> String {
  string.crop(log_line, " ")
  |> string.trim()
}

pub fn log_level(log_line: String) -> String {
  case log_line {
    "[INFO]:" <> _rest -> "info"
    "[WARNING]:" <> _rest -> "warning"
    "[ERROR]:" <> _rest -> "error"
    _ -> ""
  }
}

pub fn reformat(log_line: String) -> String {
  message(log_line) <> " (" <> log_level(log_line) <> ")"
}
