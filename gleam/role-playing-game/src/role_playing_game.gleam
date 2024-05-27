import gleam/option.{type Option, None, Some}

pub type Player {
  Player(name: Option(String), level: Int, health: Int, mana: Option(Int))
}

pub fn introduce(player: Player) -> String {
  case player.name {
    Some(name) -> name
    None -> "Mighty Magician"
  }
}

pub fn revive(player: Player) -> Option(Player) {
  let resurect_player = fn(player: Player) -> Player {
    case player.level {
      i if i < 10 -> Player(..player, health: 100)
      _ -> Player(..player, health: 100, mana: Some(100))
    }
  }

  case player.health {
    0 -> Some(resurect_player(player))
    _ -> None
  }
}

fn reduce_healt_for_non_casters_when_casting(player: Player, cost: Int) -> Int {
  let health = player.health - cost

  case health {
    i if i < 0 -> 0
    _ -> health
  }
}

pub fn cast_spell(player: Player, cost: Int) -> #(Player, Int) {
  case player.mana {
    None -> {
      let new_health = reduce_healt_for_non_casters_when_casting(player, cost)
      #(Player(..player, health: new_health), 0)
    }
    Some(i) if i > cost -> {
      let new_mana = option.unwrap(player.mana, 0) - cost
      #(Player(..player, mana: Some(new_mana)), cost * 2)
    }
    Some(_) -> #(player, 0)
  }
}
