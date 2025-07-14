import Foundation

protocol CreateTrackerDelegate: AnyObject {
  func trackerCreated(tracker: TrackerCreateDTO, categoryId: Identifier)
}
