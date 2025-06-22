import Foundation

private let daysOfWeek: [(index: Int, titleShort: String, titleFull: String)] = {
  let formatter = DateFormatter()
  formatter.locale = Locale(identifier: "ru_RU")
  let titlesFull = formatter.weekdaySymbols ?? []
  let titlesShort = formatter.shortWeekdaySymbols ?? []
  let days = titlesFull.enumerated().map { (index, titleFull) in
    let titleShort = titlesShort[index]
    return (index: index, titleShort: titleShort, titleFull: titleFull.capitalized)
  }
  return days
}()

enum DayOfWeek: Int, CaseIterable, Hashable {
  case mon = 2
  case tue = 3
  case wed = 4
  case thu = 5
  case fri = 6
  case sat = 7
  case sun = 1

  var titleShort: String {
    daysOfWeek[self.rawValue - 1].titleShort
  }

  var titleFull: String {
    daysOfWeek[self.rawValue - 1].titleFull
  }
}
