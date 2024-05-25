pub fn secret_add(secret: Int) -> fn(Int) -> Int {
  let adder = fn(x) { secret + x }
  adder
}

pub fn secret_subtract(secret: Int) -> fn(Int) -> Int {
  let subtractor = fn(x) { x - secret }
  subtractor
}

pub fn secret_multiply(secret: Int) -> fn(Int) -> Int {
  let multiplier = fn(x) { secret * x }
  multiplier
}

pub fn secret_divide(secret: Int) -> fn(Int) -> Int {
  let divider = fn(x) { x / secret }
  divider
}

pub fn secret_combine(f: fn(Int) -> Int, g: fn(Int) -> Int) -> fn(Int) -> Int {
  let combined = fn(x) {
    f(x)
    |> g
  }
  combined
}
