import gleam/int

fn is_divisible_by(dividend: Int, divisor: Int) -> Bool {
  dividend % divisor == 0
}

pub fn convert(number: Int) -> String {
  let is_divisible_by_3 = is_divisible_by(number, 3)
  let is_divisible_by_5 = is_divisible_by(number, 5)
  let is_divisible_by_7 = is_divisible_by(number, 7)
  case is_divisible_by_3, is_divisible_by_5, is_divisible_by_7 {
    True, True, True -> "PlingPlangPlong"
    True, True, False -> "PlingPlang"
    True, False, True -> "PlingPlong"
    False, True, True -> "PlangPlong"
    True, False, False -> "Pling"
    False, True, False -> "Plang"
    False, False, True -> "Plong"
    _, _, _ -> int.to_string(number)
  }
}
