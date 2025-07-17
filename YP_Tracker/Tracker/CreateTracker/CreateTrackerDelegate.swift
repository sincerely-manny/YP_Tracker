import Foundation

protocol CreateTrackerDelegate: AnyObject {
  func trackerCreated(tracker: TrackerCreateDTO, categoryId: Identifier)
  func trackerUpdated(tracker: Tracker, categoryId: Identifier)
}
