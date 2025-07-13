import Foundation

protocol TrackerCollectionViewCellDelegate: AnyObject {
  func didTapCompletionButton(for tracker: Tracker, with cell: TrackerCollectionViewCell)
}
