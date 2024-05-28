pub fn convert(number: Int) -> String {
  case number {
    number if number >= 1000 -> "M" <> convert(number - 1000)
    number if number >= 900 -> "CM" <> convert(number - 900)
    number if number >= 500 -> "D" <> convert(number - 500)
    number if number >= 400 -> "CD" <> convert(number - 400)
    number if number >= 100 -> "C" <> convert(number - 100)
    number if number >= 90 -> "XC" <> convert(number - 90)
    number if number >= 50 -> "L" <> convert(number - 50)
    number if number >= 40 -> "XL" <> convert(number - 40)
    number if number >= 10 -> "X" <> convert(number - 10)
    number if number >= 9 -> "IX" <> convert(number - 9)
    number if number >= 5 -> "V" <> convert(number - 5)
    number if number >= 4 -> "IV" <> convert(number - 4)
    number if number >= 1 -> "I" <> convert(number - 1)
    _ -> ""
  }
}
