import Foundation
import UIKit

final class DataProvider: NSObject {
  static let shared = DataProvider()

  private let trackerStore: TrackerStore
  private let trackerCategoryStore: TrackerCategoryStore
  private let trackerRecordStore: TrackerRecordStore

  private override init() {
    let context = CoreDataStack.shared.viewContext
    self.trackerStore = TrackerStore(context: context)
    self.trackerCategoryStore = TrackerCategoryStore(context: context)
    self.trackerRecordStore = TrackerRecordStore(context: context)
    super.init()
  }

  // MARK: - Tracker Methods

  func createTracker(tracker: TrackerCreateDTO, categoryId: Identifier) throws {
    _ = try trackerStore.createTracker(with: tracker, categoryId: categoryId)
  }

  func fetchTrackers() -> [Tracker] {
    return trackerStore.fetchTrackers()
  }

  // MARK: - Category Methods

  func createCategory(name: String) throws -> TrackerCategory {
    let result = try trackerCategoryStore.createCategory(with: name)
    return TrackerCategory(
      id: result.objectID,
      name: result.name ?? "",
      trackers: []
    )
  }

  func fetchCategories() -> [TrackerCategory] {
    return trackerCategoryStore.fetchCategories()
  }

  // MARK: - Record Methods

  func createRecord(trackerId: Identifier, date: Date) throws {
    _ = try trackerRecordStore.addRecord(trackerId: trackerId, date: date)
  }

  func fetchRecords() -> [TrackerRecord] {
    return trackerRecordStore.allRecords()
  }

  func fetchRecords(for trackerId: Identifier) -> [TrackerRecord] {
    return trackerRecordStore.fetchRecords(for: trackerId)
  }
}
