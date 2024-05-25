// TODO: please define the Pizza custom type
import gleam/list

pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(Pizza)
  ExtraToppings(Pizza)
}

fn get_pizza_price(pizza: Pizza, acc: Int) -> Int {
  case pizza {
    Margherita -> 7 + acc
    Caprese -> 9 + acc
    Formaggio -> 10 + acc
    ExtraToppings(p) -> get_pizza_price(p, acc + 2)
    ExtraSauce(p) -> get_pizza_price(p, acc + 1)
  }
}

pub fn pizza_price(pizza: Pizza) -> Int {
  get_pizza_price(pizza, 0)
}

pub fn order_price(order: List(Pizza)) -> Int {
  let extra_cost = case list.length(order) {
    1 -> 3
    2 -> 2
    _ -> 0
  }
  list.fold(order, 0, fn(acc, pizza) { pizza_price(pizza) + acc }) + extra_cost
}
