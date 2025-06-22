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
  return Array(days[1...6] + days[0...0])
}()

enum DayOfWeek: Int, CaseIterable, Hashable {
  case mon
  case tue
  case wed
  case thu
  case fri
  case sat
  case sun

  var index: Int {
    self.rawValue
  }

  var titleShort: String {
    daysOfWeek[self.index].titleShort
  }

  var titleFull: String {
    daysOfWeek[self.index].titleFull
  }
}
