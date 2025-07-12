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

enum DayOfWeek: Int, CaseIterable, Hashable, Codable {
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

extension Array where Element == DayOfWeek {
  func toJSON() -> String {
    do {
      let jsonData = try JSONEncoder().encode(self)
      if let jsonString = String(data: jsonData, encoding: .utf8) {
        return jsonString
      }
    } catch {
      assertionFailure("Failed to encode DayOfWeek array: \(error)")
    }
    return "[]"
  }

  static func fromJSON(_ json: String?) -> [DayOfWeek]? {
    guard let json else { return nil }

    guard let jsonData = json.data(using: .utf8) else {
      return nil
    }
    do {
      return try JSONDecoder().decode([DayOfWeek].self, from: jsonData)
    } catch {
      assertionFailure("Failed to decode DayOfWeek array: \(error)")
      return nil
    }
  }
}

typealias TrackerSchedule = [DayOfWeek]
