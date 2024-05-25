import gleam/list

pub fn today(days: List(Int)) -> Int {
  case days {
    [] -> 0
    [today_count, ..] -> today_count
  }
}

pub fn increment_day_count(days: List(Int)) -> List(Int) {
  case days {
    [] -> [1]
    [first, ..rest] -> [first + 1, ..rest]
  }
}

pub fn has_day_without_birds(days: List(Int)) -> Bool {
  list.any(days, fn(x) { x == 0 })
}

pub fn total(days: List(Int)) -> Int {
  let total = list.reduce(days, fn(acc, x) { x + acc })

  case total {
    Ok(i) -> i
    _ -> 0
  }
}

pub fn busy_days(days: List(Int)) -> Int {
  let busy_days =
    list.fold(days, 0, fn(acc, x) {
      case x {
        x if x >= 5 -> acc + 1
        _ -> acc
      }
    })
  busy_days
}
