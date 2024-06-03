import gleam/bool
import gleam/io
import gleam/list
import gleam/result

pub opaque type Frame {
  Frame(rolls: List(Int), bonus: List(Int))
}

pub type Game {
  Game(frames: List(Frame))
}

pub type Error {
  InvalidPinCount
  GameComplete
  GameNotComplete
}

pub type Completion {
  Incomplete
  Complete
}

pub type FrameState {
  Strike(Completion)
  Spare(Completion)
  Normal(Completion)
}

pub type GameState {
  GameState(Completion)
}

fn add_bonus_to_frame(frame: Frame, points: Int) -> Result(Frame, Error) {
  let frame_state = get_frame_state(frame)
  case frame_state {
    Strike(Incomplete) | Spare(Incomplete) ->
      Ok(Frame(rolls: frame.rolls, bonus: [points, ..frame.bonus]))
    _ -> Ok(frame)
  }
}

fn add_bonus_to_game(game: Game, points: Int) -> Result(Game, Error) {
  use <- bool.guard(is_game_ended(game), Error(GameComplete))
  use <- bool.guard(points < 0 || points > 10, Error(InvalidPinCount))

  let last_frame = get_game_last_frame(game)
  let last_frame_total_bunus =
    list.fold(last_frame.bonus, 0, fn(acc, x) { acc + x })
  let last_fram_bonus_length = list.length(last_frame.bonus)

  use <- bool.guard(
    are_normal_rolls_completed(game)
      && last_fram_bonus_length == 1
      && last_frame_total_bunus < 10
      && last_frame_total_bunus + points > 10,
    Error(InvalidPinCount),
  )

  use <- bool.guard(
    are_normal_rolls_completed(game) && last_fram_bonus_length == 2,
    Error(GameComplete),
  )

  let last_frame_state = get_frame_state(last_frame)
  case last_frame_state, game.frames {
    Strike(Complete), _ | Spare(Complete), _ | Normal(Complete), _ -> Ok(game)
    _, [] -> Ok(game)
    _, [frame, ..rest] -> {
      use game <- result.try(add_bonus_to_game(Game(frames: rest), points))
      use frame <- result.try(add_bonus_to_frame(frame, points))
      Ok(Game(frames: [frame, ..game.frames]))
    }
  }
}

fn are_normal_rolls_completed(game: Game) -> Bool {
  let rounds = list.length(game.frames)
  use <- bool.guard(rounds < 10, False)
  let last_frame_state = get_game_last_frame(game) |> get_frame_state()
  case last_frame_state {
    Normal(Incomplete) -> False
    _ -> True
  }
}

fn add_points_to_game(game: Game, points: Int) -> Result(Game, Error) {
  use game <- result.try(add_bonus_to_game(game, points))

  // Check if the game is in a state where we can add points
  // If the game is complete, we cannot add more points
  use <- bool.guard(are_normal_rolls_completed(game), Ok(game))

  let last_frame_state = get_game_last_frame(game) |> get_frame_state()
  case last_frame_state, game.frames {
    // if we can add to the last Frame
    Normal(Incomplete), [a, ..rest] -> {
      let total_points =
        list.fold(a.rolls, 0, fn(roll, acc) { acc + roll }) + points
      use <- bool.guard(total_points > 10, Error(InvalidPinCount))
      let new_frame = Frame(rolls: [points, ..a.rolls], bonus: a.bonus)
      Ok(Game(frames: [new_frame, ..rest]))
    }
    // if we have to add a new frame
    _, frames -> {
      let new_frame = Frame(rolls: [points], bonus: [])
      Ok(Game(frames: [new_frame, ..frames]))
    }
  }
}

pub fn roll(game: Game, knocked_pins: Int) -> Result(Game, Error) {
  use <- bool.guard(
    knocked_pins < 0 || knocked_pins > 10,
    Error(InvalidPinCount),
  )
  use <- bool.guard(is_game_ended(game), Error(GameComplete))

  add_points_to_game(game, knocked_pins)
}

pub fn score(game: Game) -> Result(Int, Error) {
  let is_game_complete = is_game_ended(game)
  case is_game_complete {
    False -> Error(GameNotComplete)
    True -> Ok(calculate_game_score(0, game))
  }
}

fn calculate_game_score(acc: Int, game: Game) -> Int {
  case game.frames {
    [] -> acc
    [a, ..rest] -> {
      let total_roll_points =
        list.fold(a.rolls, 0, fn(acc, roll) { acc + roll })
      let bunus_points = list.fold(a.bonus, 0, fn(acc, roll) { acc + roll })
      let acc = acc + total_roll_points + bunus_points
      calculate_game_score(acc, Game(frames: rest))
    }
  }
}

// Check the state of a frame
fn get_frame_state(frame: Frame) -> FrameState {
  let number_rolls = list.length(frame.rolls)
  let total_points = list.fold(frame.rolls, 0, fn(roll, acc) { acc + roll })
  let total_accounted_bonus = list.fold(frame.bonus, 0, fn(acc, _) { acc + 1 })

  case number_rolls, total_points, total_accounted_bonus {
    1, 10, 2 -> Strike(Complete)
    1, 10, i if i < 2 -> Strike(Incomplete)
    2, 10, 0 -> Spare(Incomplete)
    2, 10, 1 -> Spare(Complete)
    2, _, _ -> Normal(Complete)
    _, _, _ -> Normal(Incomplete)
  }
}

// Get the last frame of the game
// If the game has not started yet, returns an empty frame
fn get_game_last_frame(game: Game) -> Frame {
  case game.frames {
    [] -> Frame(rolls: [], bonus: [])
    [a, ..] -> a
  }
}

// get the state of the game
fn get_game_state(game: Game) -> GameState {
  let number_of_frames = list.length(game.frames)
  let last_frame = get_game_last_frame(game)
  let last_frame_state = get_frame_state(last_frame)
  case number_of_frames, last_frame_state {
    i, _ if i < 10 -> GameState(Incomplete)
    10, frame_state
      if frame_state == Strike(Incomplete)
      || frame_state == Spare(Incomplete)
      || frame_state == Normal(Incomplete)
    -> GameState(Incomplete)
    _, _ -> GameState(Complete)
  }
}

fn is_game_ended(game: Game) -> Bool {
  let GameState(state) = get_game_state(game)
  state == Complete
}
