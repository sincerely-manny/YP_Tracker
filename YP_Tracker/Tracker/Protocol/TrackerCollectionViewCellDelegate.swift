import Foundation

protocol TrackerCollectionViewCellDelegate: AnyObject {
  func didTapCompletionButton(for tracker: Tracker, with cell: TrackerCollectionViewCell)
  func trackerCompletedTimes(id: UUID) -> Int
  func trackerCompletedForDate(id: UUID, date: Date) -> Bool
}
