import SnapshotTesting
import Testing
import XCTest

@testable import YP_Tracker

final class YP_TrackerTests: XCTestCase {

  func testIndexViewController() {
    let vc = IndexTabbarController()

    assertSnapshot(matching: vc, as: .image)
  }

}
