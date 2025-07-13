import Foundation
import UIKit

extension TrackerViewController: TrackerCollectionViewCellDelegate {
  func didTapCompletionButton(for tracker: Tracker, with cell: TrackerCollectionViewCell) {
    guard selectedDate <= Date.now else {
      return
    }
    let trackerCompletedForDate =
      trackerRecords
      .contains {
        Calendar.current.isDate($0.date, inSameDayAs: selectedDate) && $0.trackerId == tracker.id
      }
    if !trackerCompletedForDate {
      try? recordStore.addRecord(trackerId: tracker.id, date: selectedDate)
    } else {
      try? recordStore.removeRecord(trackerId: tracker.id, date: selectedDate)
    }
  }

}
