import gleam/dict.{type Dict}
import gleam/queue.{type Queue}
import gleam/result

pub opaque type CircularBuffer(t) {
  CircularBuffer(value: Queue(t), capacity: Int)
}

pub fn new(capacity: Int) -> CircularBuffer(t) {
  let buffer = queue.new()
  CircularBuffer(buffer, capacity)
}

pub fn read(buffer: CircularBuffer(t)) -> Result(#(t, CircularBuffer(t)), Nil) {
  use #(deleted_value, queue) <- result.try(queue.pop_front(buffer.value))
  let capacity = buffer.capacity
  Ok(#(deleted_value, CircularBuffer(queue, capacity)))
}

pub fn write(
  buffer: CircularBuffer(t),
  item: t,
) -> Result(CircularBuffer(t), Nil) {
  let capacity = buffer.capacity
  let buffer_current_size = queue.length(buffer.value)
  case buffer_current_size >= capacity {
    True -> Error(Nil)
    False -> {
      let new_queue = buffer.value |> queue.push_back(item)
      Ok(CircularBuffer(new_queue, capacity))
    }
  }
}

pub fn overwrite(buffer: CircularBuffer(t), item: t) -> CircularBuffer(t) {
  let capacity = buffer.capacity
  let current_size = queue.length(buffer.value)

  let queue = case current_size >= capacity {
    False -> buffer.value
    True -> {
      let result = queue.pop_front(buffer.value)
      case result {
        Ok(#(_, buffer)) -> buffer
        Error(_) -> buffer.value
      }
    }
  }
  let new_queue = queue |> queue.push_back(item)
  CircularBuffer(new_queue, capacity)
}

pub fn clear(buffer: CircularBuffer(t)) -> CircularBuffer(t) {
  new(buffer.capacity)
}
