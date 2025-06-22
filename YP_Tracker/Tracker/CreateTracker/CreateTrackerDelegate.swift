import Foundation

protocol CreateTrackerDelegate: AnyObject {
  func trackerCreated(tracker: Tracker, categoryId: UUID)
}
