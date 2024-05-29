import gleam/string

// Please define the TreasureChest type
pub opaque type TreasureChest(treasure) {
  TreasureChest(String, treasure)
}

pub fn create(
  password: String,
  contents: treasure,
) -> Result(TreasureChest(treasure), String) {
  case string.length(password) {
    i if i < 8 -> Error("Password must be at least 8 characters long")
    _ -> Ok(TreasureChest(password, contents))
  }
}

pub fn open(
  chest: TreasureChest(treasure),
  password: String,
) -> Result(treasure, String) {
  case chest {
    TreasureChest(pw, treasure) if pw == password -> Ok(treasure)
    TreasureChest(_, _) -> Error("Incorrect password")
  }
}
