import Foundation
import UIKit

struct Tracker {
  let id: UUID
  let name: String
  let color: UIColor
  let emoji: String
  let schedule: TrackerSchedule?
}

struct TrackerSchedule {
  let id: String
}
