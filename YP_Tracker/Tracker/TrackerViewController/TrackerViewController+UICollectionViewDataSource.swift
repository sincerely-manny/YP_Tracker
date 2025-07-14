import UIKit

extension TrackerViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if filteredTrackers.isEmpty {
      collectionView.backgroundView?.isHidden = false
    } else {
      collectionView.backgroundView?.isHidden = true
    }

    return filteredTrackers.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int
  {
    return filteredTrackers[section].trackers.count
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

    let tracker = filteredTrackers[indexPath.section].trackers[indexPath.item]
    cell.delegate = self
    let records = trackerRecords.filter { $0.trackerId == tracker.id }
    cell.isCompleted =
      records.contains { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    cell.trackerCompletedTimes = records.count
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
      header.configure(with: filteredTrackers[indexPath.section].name)
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
