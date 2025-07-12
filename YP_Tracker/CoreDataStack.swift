import CoreData
import UIKit

class CoreDataStack {
  static let shared = CoreDataStack()

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Model")
    container.loadPersistentStores { description, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()

  var viewContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }

  func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        assertionFailure("Unresolved error \(error), \((error as NSError).userInfo)")
      }
    }
  }
}

typealias Identifier = NSManagedObjectID
