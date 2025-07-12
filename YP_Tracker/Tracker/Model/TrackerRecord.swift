import Foundation

struct TrackerRecord {
  let id: Identifier
  let trackerId: Identifier
  let date: Date
}

struct TrackerRecordCreateDTO {
  let trackerId: Identifier
  let date: Date
}
