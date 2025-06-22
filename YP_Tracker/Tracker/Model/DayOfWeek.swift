import Foundation

struct DayOfWeek: Hashable, Equatable {
  let index: Int
  let titleShort: String
  let titleFull: String
}

let daysOfWeek: [DayOfWeek] = {
  let formatter = DateFormatter()
  formatter.locale = Locale(identifier: "ru_RU")
  let titlesFull = formatter.weekdaySymbols ?? []
  let titlesShort = formatter.shortWeekdaySymbols ?? []
  let days = titlesFull.enumerated().map { (index, titleFull) in
    let titleShort = titlesShort[index]
    return DayOfWeek(index: index, titleShort: titleShort, titleFull: titleFull.capitalized)
  }
  return Array(days[1...6] + days[0...0])
}()
