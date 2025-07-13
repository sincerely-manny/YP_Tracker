import Foundation
import UIKit

struct Tracker {
  let id: Identifier
  let name: String
  let color: String
  let emoji: String
  let schedule: TrackerSchedule?
  let records: [TrackerRecord]
}

struct TrackerCreateDTO {
  let name: String
  let color: String
  let emoji: String
  let schedule: TrackerSchedule?
}
