import Foundation
import UIKit

struct Tracker {
  let id: UUID
  let name: String
  let color: String
  let emoji: String
  let schedule: [DayOfWeek]?
}
