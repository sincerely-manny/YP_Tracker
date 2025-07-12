import Foundation

protocol TrackerCollectionViewCellDelegate: AnyObject {
  func didTapCompletionButton(for tracker: Tracker, with cell: TrackerCollectionViewCell)
  func trackerCompletedTimes(id: Identifier) -> Int
  func trackerCompletedForDate(id: Identifier, date: Date) -> Bool
}
