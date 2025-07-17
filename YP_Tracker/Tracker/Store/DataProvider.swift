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

  static func getTrackerStore(delegate: TrackerStoreDelegate?) -> TrackerStore {
    let context = CoreDataStack.shared.viewContext
    let store = TrackerStore(context: context)
    store.delegate = delegate
    return store
  }

  static func getTrackerCategoryStore(delegate: TrackerCategoryStoreDelegate?)
    -> TrackerCategoryStore
  {
    let context = CoreDataStack.shared.viewContext
    let store = TrackerCategoryStore(context: context)
    store.delegate = delegate
    return store
  }

  static func getTrackerRecordStore(delegate: TrackerRecordStoreDelegate?) -> TrackerRecordStore {
    let context = CoreDataStack.shared.viewContext
    let store = TrackerRecordStore(context: context)
    store.delegate = delegate
    return store
  }
}
