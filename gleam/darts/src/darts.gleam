import gleam/float

pub fn score(x: Float, y: Float) -> Int {
  let distance = point_distance_from_center(x, y)
  case distance {
    Ok(d) if d <=. 1.0 -> 10
    Ok(d) if d <=. 5.0 -> 5
    Ok(d) if d <=. 10.0 -> 1
    _ -> 0
  }
}

fn point_distance_from_center(x: Float, y: Float) -> Result(Float, Nil) {
  float.square_root(x *. x +. y *. y)
}
