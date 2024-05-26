import gleam/list
import gleam/order.{type Order}

pub type City {
  City(name: String, temperature: Temperature)
}

pub type Temperature {
  Celsius(Float)
  Fahrenheit(Float)
}

pub const conversion_factor = 1.8

pub fn fahrenheit_to_celsius(f: Float) -> Float {
  { f -. 32.0 } /. conversion_factor
}

pub fn compare_temperature(left: Temperature, right: Temperature) -> Order {
  let #(x, y) = case left, right {
    Celsius(l), Celsius(r) -> #(l, r)
    Celsius(l), Fahrenheit(r) -> #(l, fahrenheit_to_celsius(r))
    Fahrenheit(l), Celsius(r) -> #(fahrenheit_to_celsius(l), r)
    Fahrenheit(l), Fahrenheit(r) -> #(l, r)
  }
  case x, y {
    x, y if x >. y -> order.Gt
    x, y if x <. y -> order.Lt
    _, _ -> order.Eq
  }
}

pub fn sort_cities_by_temperature(cities: List(City)) -> List(City) {
  list.sort(cities, by: fn(city1, city2) {
    compare_temperature(city1.temperature, city2.temperature)
  })
}
