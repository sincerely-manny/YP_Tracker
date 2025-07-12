import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
  func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate)
}

struct TrackerRecordStoreUpdate {
  let insertedIndexPaths: [IndexPath]
  let deletedIndexPaths: [IndexPath]
  let updatedIndexPaths: [IndexPath]
}

final class TrackerRecordStore: NSObject {
  private let context: NSManagedObjectContext
  private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
    let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]

    let controller = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil
    )
    controller.delegate = self
    try? controller.performFetch()
    return controller
  }()

  weak var delegate: TrackerRecordStoreDelegate?
  private var insertedIndexPaths: [IndexPath] = []
  private var deletedIndexPaths: [IndexPath] = []
  private var updatedIndexPaths: [IndexPath] = []

  init(context: NSManagedObjectContext) {
    self.context = context
    super.init()
  }

  @discardableResult
  func addRecord(trackerId: Identifier, date: Date) throws -> TrackerRecordCoreData {
    guard let tracker = context.object(with: trackerId) as? TrackerCoreData else {
      assertionFailure("Tracker with ID \(trackerId) not found")
      throw NSError(
        domain: "TrackerRecordStore", code: 1,
        userInfo: [NSLocalizedDescriptionKey: "Tracker not found"])
    }

    let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
    let startOfDay = calendar.date(from: dateComponents) ?? date
    let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date

    fetchRequest.predicate = NSPredicate(
      format: "tracker == %@ AND date >= %@ AND date < %@",
      tracker,
      startOfDay as NSDate,
      endOfDay as NSDate
    )

    if let existingRecords = try? context.fetch(fetchRequest), !existingRecords.isEmpty {
      return existingRecords[0]
    }

    let record = TrackerRecordCoreData(context: context)
    record.date = date
    record.tracker = tracker

    try context.save()
    return record
  }

  func removeRecord(trackerId: Identifier, date: Date) throws {
    guard let tracker = context.object(with: trackerId) as? TrackerCoreData else {
      assertionFailure("Tracker with ID \(trackerId) not found")
      throw NSError(
        domain: "TrackerRecordStore", code: 1,
        userInfo: [NSLocalizedDescriptionKey: "Tracker not found"])
    }

    let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
    let startOfDay = calendar.date(from: dateComponents) ?? date
    let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date

    fetchRequest.predicate = NSPredicate(
      format: "tracker == %@ AND date >= %@ AND date < %@",
      tracker,
      startOfDay as NSDate,
      endOfDay as NSDate
    )

    if let records = try? context.fetch(fetchRequest), let record = records.first {
      context.delete(record)
      try context.save()
    }
  }

  func hasRecord(trackerId: Identifier, date: Date) -> Bool {
    guard let tracker = try? context.existingObject(with: trackerId) as? TrackerCoreData else {
      return false
    }

    let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
    let startOfDay = calendar.date(from: dateComponents) ?? date
    let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date

    fetchRequest.predicate = NSPredicate(
      format: "tracker == %@ AND date >= %@ AND date < %@",
      tracker,
      startOfDay as NSDate,
      endOfDay as NSDate
    )

    do {
      let records = try context.fetch(fetchRequest)
      return !records.isEmpty
    } catch {
      return false
    }
  }

  func recordsCount(trackerId: Identifier) -> Int {
    guard let tracker = try? context.existingObject(with: trackerId) as? TrackerCoreData else {
      return 0
    }

    let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    fetchRequest.predicate = NSPredicate(format: "tracker == %@", tracker)

    do {
      return try context.count(for: fetchRequest)
    } catch {
      return 0
    }
  }

  func allRecords() -> [TrackerRecord] {
    guard let recordsCoreData = fetchedResultsController.fetchedObjects else { return [] }

    return recordsCoreData.compactMap { record -> TrackerRecord? in
      guard let tracker = record.tracker,
        let date = record.date
      else { return nil }

      return TrackerRecord(
        id: record.objectID,
        trackerId: tracker.objectID,
        date: date
      )
    }
  }

  func fetchRecords(for trackerId: Identifier) -> [TrackerRecord] {
    guard let tracker = try? context.existingObject(with: trackerId) as? TrackerCoreData else {
      return []
    }

    let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    fetchRequest.predicate = NSPredicate(format: "tracker == %@", tracker)

    guard let records = try? context.fetch(fetchRequest) else { return [] }

    return records.compactMap { record -> TrackerRecord? in
      guard let date = record.date else { return nil }
      return TrackerRecord(
        id: record.objectID,
        trackerId: tracker.objectID,
        date: date
      )
    }
  }

  func recordsForDate(_ date: Date) -> [TrackerRecord] {
    let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
    let startOfDay = calendar.date(from: dateComponents) ?? date
    let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date

    fetchRequest.predicate = NSPredicate(
      format: "date >= %@ AND date < %@",
      startOfDay as NSDate,
      endOfDay as NSDate
    )

    guard let records = try? context.fetch(fetchRequest) else { return [] }

    return records.compactMap { record -> TrackerRecord? in
      guard let tracker = record.tracker,
        let date = record.date
      else { return nil }

      return TrackerRecord(
        id: record.objectID,
        trackerId: tracker.objectID,
        date: date
      )
    }
  }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    insertedIndexPaths = []
    deletedIndexPaths = []
    updatedIndexPaths = []
  }

  func controller(
    _ controller: NSFetchedResultsController<NSFetchRequestResult>,
    didChange anObject: Any,
    at indexPath: IndexPath?,
    for type: NSFetchedResultsChangeType,
    newIndexPath: IndexPath?
  ) {
    switch type {
    case .insert:
      if let indexPath = newIndexPath {
        insertedIndexPaths.append(indexPath)
      }
    case .delete:
      if let indexPath = indexPath {
        deletedIndexPaths.append(indexPath)
      }
    case .update:
      if let indexPath = indexPath {
        updatedIndexPaths.append(indexPath)
      }
    case .move:
      break
    @unknown default:
      break
    }
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    delegate?.store(
      self,
      didUpdate: TrackerRecordStoreUpdate(
        insertedIndexPaths: insertedIndexPaths,
        deletedIndexPaths: deletedIndexPaths,
        updatedIndexPaths: updatedIndexPaths
      )
    )
  }
}
