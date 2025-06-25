enum TrackerType: Int, CaseIterable, Hashable {
  case habit
  case irregularEvent

  var title: String {
    switch self {
    case .habit:
      return "Привычка"
    case .irregularEvent:
      return "Нерегулярное событие"
    }
  }
}
