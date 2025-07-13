import UIKit

extension TrackerViewController: TrackerStoreDelegate {
  func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
    categories = trackerCategoryStore.fetchCategories()
  }
}

extension TrackerViewController: TrackerCategoryStoreDelegate {
  func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
    categories = trackerCategoryStore.fetchCategories()
  }
}

extension TrackerViewController: TrackerRecordStoreDelegate {
  func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
    trackerRecords = recordStore.allRecords()
    guard let collectionView,
      let indexPath = findIndexPath(for: update.trackerId)
    else {
      return
    }

    collectionView.reloadItems(at: [indexPath])
  }

  private func findIndexPath(for trackerId: Identifier) -> IndexPath? {
    for (sectionIndex, category) in filteredTrackers.enumerated() {
      if let itemIndex = category.trackers.firstIndex(where: { $0.id == trackerId }) {
        return IndexPath(item: itemIndex, section: sectionIndex)
      }
    }
    return nil
  }
}
