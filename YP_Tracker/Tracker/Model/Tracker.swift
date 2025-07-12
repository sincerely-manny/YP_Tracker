import Foundation
import UIKit

struct Tracker {
  let id: Identifier
  let name: String
  let color: String
  let emoji: String
  let schedule: TrackerSchedule?
}

struct TrackerCreateDTO {
  let name: String
  let color: String
  let emoji: String
  let schedule: TrackerSchedule?
}
