pub fn is_leap_year(year: Int) -> Bool {
  let is_400_multiple = year % 400 == 0
  let is_100_multiple = year % 100 == 0
  let is_4_multiple = year % 4 == 0
  case is_400_multiple, is_100_multiple, is_4_multiple {
    True, _, _ -> True
    _, True, _ -> False
    _, _, True -> True
    _, _, _ -> False
  }
}
