import CoreData

protocol TrackerStoreDelegate: AnyObject {
  func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate)
}

struct TrackerStoreUpdate {
  let insertedIndexPaths: [IndexPath]
  let deletedIndexPaths: [IndexPath]
  let updatedIndexPaths: [IndexPath]
  let movedIndexPaths: [(IndexPath, IndexPath)]
}

final class TrackerStore: NSObject {
  static let entityName = "TrackerCoreData"
  private let context: NSManagedObjectContext
  private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
    let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: TrackerStore.entityName)
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

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

  weak var delegate: TrackerStoreDelegate?
  private var insertedIndexPaths: [IndexPath] = []
  private var deletedIndexPaths: [IndexPath] = []
  private var updatedIndexPaths: [IndexPath] = []
  private var movedIndexPaths: [(IndexPath, IndexPath)] = []

  init(context: NSManagedObjectContext) {
    self.context = context
    super.init()
  }

  @discardableResult
  func createTracker(with tracker: TrackerCreateDTO, categoryId: Identifier) throws
    -> TrackerCoreData
  {
    let trackerCoreData = TrackerCoreData(context: context)
    trackerCoreData.name = tracker.name
    trackerCoreData.color = tracker.color
    trackerCoreData.emoji = tracker.emoji

    if let schedule = tracker.schedule {
      trackerCoreData.schedule = schedule.toJSON()
    } else {
      trackerCoreData.schedule = nil
    }

    if let category = context.object(with: categoryId) as? TrackerCategoryCoreData {
      trackerCoreData.category = category
    } else {
      assertionFailure("Category with ID \(categoryId) not found")
    }

    try context.save()
    return trackerCoreData
  }

  func fetchTrackers() -> [Tracker] {
    guard let trackersCoreData = fetchedResultsController.fetchedObjects else { return [] }

    return trackersCoreData.map { TrackerStore.fromCoreData($0) }
  }

  func fetchTracker(for trackerId: Identifier) -> Tracker? {
    guard let trackerCoreData = context.object(with: trackerId) as? TrackerCoreData else {
      assertionFailure("Tracker with ID \(trackerId) not found")
      return nil
    }
    return TrackerStore.fromCoreData(trackerCoreData)
  }

  static func fromCoreData(_ trackerCoreData: TrackerCoreData) -> Tracker {
    return Tracker(
      id: trackerCoreData.objectID,
      name: trackerCoreData.name ?? "",
      color: trackerCoreData.color ?? "",
      emoji: trackerCoreData.emoji ?? "",
      schedule: TrackerSchedule.fromJSON(trackerCoreData.schedule),
      records: trackerCoreData.records?.compactMap { data in
        guard let record = data as? TrackerRecordCoreData else { return nil }
        return TrackerRecord(
          id: record.objectID,
          trackerId: record.tracker?.objectID ?? NSManagedObjectID(),
          date: record.date ?? Date()
        )
      } ?? []
    )
  }

  func deleteTracker(with id: Identifier) throws {
    if let trackerCoreData = context.object(with: id) as? TrackerCoreData {
      context.delete(trackerCoreData)
      try context.save()
    } else {
      assertionFailure("Tracker with ID \(id) not found")
    }
  }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    insertedIndexPaths = []
    deletedIndexPaths = []
    updatedIndexPaths = []
    movedIndexPaths = []
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
      if let indexPath = indexPath, let newIndexPath = newIndexPath {
        movedIndexPaths.append((indexPath, newIndexPath))
      }
    @unknown default:
      break
    }
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    delegate?.store(
      self,
      didUpdate: TrackerStoreUpdate(
        insertedIndexPaths: insertedIndexPaths,
        deletedIndexPaths: deletedIndexPaths,
        updatedIndexPaths: updatedIndexPaths,
        movedIndexPaths: movedIndexPaths
      )
    )
  }
}
