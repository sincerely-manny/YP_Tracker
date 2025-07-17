import AppMetricaCore

final class Analytics {
  enum EventType: String {
    case open = "open"
    case close = "close"
    case click = "click"
  }

  enum ScreenType: String {
    case main = "Main"
  }

  enum ItemType: String {
    case add_track = "add_track"
    case track = "track"
    case filter = "filter"
    case edit = "edit"
    case delete = "delete"
  }

  static func reportOpen(screen: ScreenType) {
    let params = ["screen": screen.rawValue]

    AppMetrica.reportEvent(
      name: EventType.open.rawValue, parameters: params,
      onFailure: { error in
        print("REPORT ERROR: %@", error.localizedDescription)
      })
  }

  static func reportClose(screen: ScreenType) {
    let params = ["screen": screen.rawValue]

    AppMetrica.reportEvent(
      name: EventType.close.rawValue, parameters: params,
      onFailure: { error in
        print("REPORT ERROR: %@", error.localizedDescription)
      })
  }

  static func reportClick(screen: ScreenType, item: ItemType) {
    let params = ["screen": screen.rawValue, "item": item.rawValue]

    AppMetrica.reportEvent(
      name: EventType.click.rawValue, parameters: params,
      onFailure: { error in
        print("REPORT ERROR: %@", error.localizedDescription)
      })
  }
}
