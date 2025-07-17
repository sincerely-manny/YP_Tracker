import Foundation

struct TrackerStatistics {
  let bestPeriod: Int
  let perfectDays: Int
  let trackersCompleted: Int
  let averageValue: Int
}

final class StatisticsService {
  private let trackerStore: TrackerStore
  private let trackerRecordStore: TrackerRecordStore

  init(trackerStore: TrackerStore, trackerRecordStore: TrackerRecordStore) {
    self.trackerStore = trackerStore
    self.trackerRecordStore = trackerRecordStore
  }

  func calculateStatistics() -> TrackerStatistics {
    let allRecords = trackerRecordStore.allRecords()
    let allTrackers = trackerStore.fetchTrackers()

    return TrackerStatistics(
      bestPeriod: calculateBestPeriod(records: allRecords),
      perfectDays: calculatePerfectDays(records: allRecords, trackers: allTrackers),
      trackersCompleted: allRecords.count,
      averageValue: calculateAverageValue(records: allRecords)
    )
  }

  private func calculateBestPeriod(records: [TrackerRecord]) -> Int {
    guard !records.isEmpty else { return 0 }

    let calendar = Calendar.current
    let recordsByDate = Dictionary(grouping: records) { record in
      calendar.startOfDay(for: record.date)
    }

    let sortedDates = recordsByDate.keys.sorted()
    guard !sortedDates.isEmpty else { return 0 }

    var maxStreak = 1
    var currentStreak = 1

    for i in 1..<sortedDates.count {
      let previousDate = sortedDates[i - 1]
      let currentDate = sortedDates[i]

      if let nextDay = calendar.date(byAdding: .day, value: 1, to: previousDate),
        calendar.isDate(nextDay, inSameDayAs: currentDate)
      {
        currentStreak += 1
        maxStreak = max(maxStreak, currentStreak)
      } else {
        currentStreak = 1
      }
    }

    return maxStreak
  }

  private func calculatePerfectDays(records: [TrackerRecord], trackers: [Tracker]) -> Int {
    guard !trackers.isEmpty else { return 0 }

    let calendar = Calendar.current

    let recordsByDate = Dictionary(grouping: records) { record in
      calendar.startOfDay(for: record.date)
    }

    var perfectDays = 0

    for (date, recordsForDate) in recordsByDate {

      let activeTrackers = getActiveTrackers(for: date, trackers: trackers)

      let completedTrackerIds = Set(recordsForDate.map { $0.trackerId })

      if !activeTrackers.isEmpty && Set(activeTrackers.map { $0.id }) == completedTrackerIds {
        perfectDays += 1
      }
    }

    return perfectDays
  }

  private func calculateAverageValue(records: [TrackerRecord]) -> Int {
    guard !records.isEmpty else { return 0 }

    let calendar = Calendar.current
    let recordsByDate = Dictionary(grouping: records) { record in
      calendar.startOfDay(for: record.date)
    }

    let uniqueDays = recordsByDate.keys.count
    return uniqueDays > 0 ? records.count / uniqueDays : 0
  }

  private func getActiveTrackers(for date: Date, trackers: [Tracker]) -> [Tracker] {
    let calendar = Calendar.current
    let weekday = calendar.component(.weekday, from: date)

    return trackers.filter { tracker in

      guard let schedule = tracker.schedule else {
        return false
      }

      return schedule.contains { dayOfWeek in
        dayOfWeek.rawValue == weekday
      }
    }
  }
}
