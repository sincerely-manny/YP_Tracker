import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
  func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate)
}

struct TrackerCategoryStoreUpdate {
  let insertedIndexPaths: [IndexPath]
  let deletedIndexPaths: [IndexPath]
  let updatedIndexPaths: [IndexPath]
}

final class TrackerCategoryStore: NSObject {
  static let entityName = "TrackerCategoryCoreData"
  private let context: NSManagedObjectContext
  private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
    let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(
      entityName: TrackerCategoryStore.entityName)
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

  weak var delegate: TrackerCategoryStoreDelegate?
  private var insertedIndexPaths: [IndexPath] = []
  private var deletedIndexPaths: [IndexPath] = []
  private var updatedIndexPaths: [IndexPath] = []

  init(context: NSManagedObjectContext) {
    self.context = context
    super.init()
  }

  @discardableResult
  func createCategory(with name: String) throws -> TrackerCategory {
    let categoryCoreData = TrackerCategoryCoreData(context: context)
    categoryCoreData.name = name
    try context.save()
    return TrackerCategory(id: categoryCoreData.objectID, name: name, trackers: [])
  }

  func fetchCategories() -> [TrackerCategory] {
    guard let categoriesCoreData = fetchedResultsController.fetchedObjects else { return [] }

    return categoriesCoreData.map { categoryCoreData in
      let trackers =
        (categoryCoreData.trackers?.allObjects as? [TrackerCoreData])?.map {
          TrackerStore.fromCoreData($0)
        } ?? []

      return TrackerCategory(
        id: categoryCoreData.objectID,
        name: categoryCoreData.name ?? "",
        trackers: trackers
      )
    }
  }

  func deleteCategory(with id: Identifier) throws {
    guard let categoryCoreData = context.object(with: id) as? TrackerCategoryCoreData else {
      assertionFailure("Category with ID \(id) not found")
      return
    }
    context.delete(categoryCoreData)
    try context.save()
  }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
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
      didUpdate: TrackerCategoryStoreUpdate(
        insertedIndexPaths: insertedIndexPaths,
        deletedIndexPaths: deletedIndexPaths,
        updatedIndexPaths: updatedIndexPaths
      )
    )
  }
}
