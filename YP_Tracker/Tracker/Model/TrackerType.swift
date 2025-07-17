import Foundation

enum TrackerType: Int, CaseIterable, Hashable {
  case habit
  case irregularEvent

  var title: String {
    switch self {
    case .habit:
      return NSLocalizedString("new_habit", comment: "Category section title")
    case .irregularEvent:
      return NSLocalizedString("new_event", comment: "Category section title")
    }
  }
}
