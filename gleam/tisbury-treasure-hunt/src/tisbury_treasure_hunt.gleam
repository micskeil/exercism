import gleam/list

pub fn place_location_to_treasure_location(
  place_location: #(String, Int),
) -> #(Int, String) {
  #(place_location.1, place_location.0)
}

pub fn treasure_location_matches_place_location(
  place_location: #(String, Int),
  treasure_location: #(Int, String),
) -> Bool {
  place_location_to_treasure_location(place_location) == treasure_location
}

pub fn count_place_treasures(
  place: #(String, #(String, Int)),
  treasures: List(#(String, #(Int, String))),
) -> Int {
  let place_normalized_location = place_location_to_treasure_location(place.1)

  let local_treasures =
    list.filter(treasures, fn(treasure) {
      treasure.1 == place_normalized_location
    })
  list.length(local_treasures)
}

pub fn special_case_swap_possible(
  found_treasure: #(String, #(Int, String)),
  place: #(String, #(String, Int)),
  desired_treasure: #(String, #(Int, String)),
) -> Bool {
  case found_treasure, place, desired_treasure {
    #("Brass_Spyglass", _), #("Abandoned Lighthouse", _), _ -> True
    #("Amethyst Octopus", _), #("Stormy Breakwater", _), #(i, _) if i
      == "Crystal Crab"
      || i == "Glass Starfish" -> True
    #("Vintage Pirate Hat", _), #("Harbor Managers Office", _), #(i, _) if i
      == "Model Ship in Large Bottle"
      || i == "Antique Glass Fishnet Float" -> True

    _, _, _ -> False
  }
}
