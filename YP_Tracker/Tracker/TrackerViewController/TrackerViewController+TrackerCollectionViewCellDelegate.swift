import Foundation

extension TrackerViewController: TrackerCollectionViewCellDelegate {
  func didTapCompletionButton(for tracker: Tracker, with cell: TrackerCollectionViewCell) {
    guard selectedDate <= Date.now else {
      return
    }
    if !trackerCompletedForDate(id: tracker.id, date: selectedDate) {
      let record = TrackerRecord(trackerId: tracker.id, date: selectedDate)
      completedTrackers.append(record)
      cell.isCompleted = true
    } else {
      guard
        let index = completedTrackers.firstIndex(where: {
          $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        })
      else {
        return
      }
      completedTrackers.remove(at: index)
      cell.isCompleted = false
    }
    cell.trackerCompletedTimes = trackerCompletedTimes(id: tracker.id)
  }

  func trackerCompletedTimes(id: UUID) -> Int {
    return completedTrackers.filter { $0.trackerId == id }.count
  }

  func trackerCompletedForDate(id: UUID, date: Date) -> Bool {
    return completedTrackers.contains {
      $0.trackerId == id && Calendar.current.isDate($0.date, inSameDayAs: date)
    }
  }
}
