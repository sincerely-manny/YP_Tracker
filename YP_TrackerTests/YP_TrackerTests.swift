import SnapshotTesting
import Testing
import XCTest

@testable import YP_Tracker

final class YP_TrackerTests: XCTestCase {

  func testIndexViewControllerLightTheme() {
    let vc = IndexTabbarController()

    assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
  }

  func testIndexViewControllerDarkTheme() {
    let vc = IndexTabbarController()

    assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
  }

}
