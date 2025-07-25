enum TrackerType: Int, CaseIterable, Hashable {
  case habit
  case irregularEvent

  var title: String {
    switch self {
    case .habit:
      return "Новая привычка"
    case .irregularEvent:
      return "Новое нерегулярное событие"
    }
  }
}
