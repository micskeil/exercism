fn sum_of_n_natural_numbers(n: Int, acc: Int, apply: fn(Int) -> Int) -> Int {
  case n {
    0 -> acc
    _ -> sum_of_n_natural_numbers(n - 1, acc + apply(n), apply)
  }
}

// Sum the first n natural numbers and square the result
pub fn square_of_sum(n: Int) -> Int {
  sum_of_n_natural_numbers(n, 0, fn(x) { x })
  * sum_of_n_natural_numbers(n, 0, fn(x) { x })
}

pub fn sum_of_squares(n: Int) -> Int {
  sum_of_n_natural_numbers(n, 0, fn(x) { x * x })
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
