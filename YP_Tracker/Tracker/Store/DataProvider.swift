import Foundation
import UIKit

final class DataProvider: NSObject {
  static let shared = DataProvider()

  let trackerStore: TrackerStore
  let trackerCategoryStore: TrackerCategoryStore
  let trackerRecordStore: TrackerRecordStore

  private override init() {
    let context = CoreDataStack.shared.viewContext
    self.trackerStore = TrackerStore(context: context)
    self.trackerCategoryStore = TrackerCategoryStore(context: context)
    self.trackerRecordStore = TrackerRecordStore(context: context)
    super.init()
  }

}
