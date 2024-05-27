import gleam/string

pub fn extract_error(problem: Result(a, b)) -> b {
  let assert Error(error_msg) = problem
  error_msg
}

pub fn remove_team_prefix(team: String) -> String {
  string.replace(team, "Team ", "")
}

pub fn split_region_and_team(combined: String) -> #(String, String) {
  let assert [country, team] = string.split(combined, ",")
  #(country, remove_team_prefix(team))
}
