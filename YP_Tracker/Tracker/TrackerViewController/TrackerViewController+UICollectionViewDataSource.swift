import UIKit

extension TrackerViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if categories.isEmpty {
      collectionView.backgroundView?.isHidden = false
    } else {
      collectionView.backgroundView?.isHidden = true
    }

    return categories.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int
  {
    return categories[section].trackers.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath)
        as? TrackerCollectionViewCell
    else {
      fatalError("Unable to dequeue TrackerCollectionViewCell")
    }

    let tracker = categories[indexPath.section].trackers[indexPath.item]
    cell.delegate = self
    cell.isCompleted = trackerCompletedForDate(id: tracker.id, date: selectedDate)
    cell.trackerCompletedTimes = trackerCompletedTimes(id: tracker.id)
    cell.configure(with: tracker)

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      guard
        let header = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind, withReuseIdentifier: TrackerCollectionViewHeader.identifier,
          for: indexPath) as? TrackerCollectionViewHeader
      else {
        fatalError("Unable to dequeue TrackerCollectionViewHeader")
      }
      header.configure(with: categories[indexPath.section].name)
      return header
    } else if kind == UICollectionView.elementKindSectionFooter {
      guard
        let footer = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind, withReuseIdentifier: TrackerCollectionViewFooter.identifier,
          for: indexPath) as? TrackerCollectionViewFooter
      else {
        fatalError("Unable to dequeue TrackerCollectionViewFooter")
      }
      return footer
    } else {
      return UICollectionReusableView()
    }
  }
}
