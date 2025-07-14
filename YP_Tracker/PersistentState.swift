import Foundation

final class PersistentState {
  static let shared = PersistentState()

  private init() {}

  private let userDefaults = UserDefaults.standard

  var isOnboardingCompleted: Bool {
    get { userDefaults.bool(forKey: "isOnboardingCompleted") }
    set { userDefaults.set(newValue, forKey: "isOnboardingCompleted") }
  }
}
