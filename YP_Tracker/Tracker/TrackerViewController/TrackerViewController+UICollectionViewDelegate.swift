import UIKit

extension TrackerViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath,
    point: CGPoint
  ) -> UIContextMenuConfiguration? {

    guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else {
      return nil
    }

    return UIContextMenuConfiguration(
      identifier: nil,
      previewProvider: {
        let previewVC = UIViewController()
        let headerPreview = cell.preview()

        headerPreview.translatesAutoresizingMaskIntoConstraints = false

        previewVC.view.addSubview(headerPreview)
        NSLayoutConstraint.activate([
          headerPreview.centerXAnchor.constraint(equalTo: previewVC.view.centerXAnchor),
          headerPreview.centerYAnchor.constraint(equalTo: previewVC.view.centerYAnchor),
          headerPreview.widthAnchor.constraint(equalToConstant: cell.header.bounds.width),
          headerPreview.heightAnchor.constraint(equalToConstant: cell.header.bounds.height),
        ])
        previewVC.preferredContentSize = CGSize(
          width: cell.header.bounds.width,
          height: cell.header.bounds.height
        )
        return previewVC
      }
    ) { _ in
      let edit = self.editAction(for: indexPath)

      let delete = self.deleteAction(for: indexPath)

      return UIMenu(title: "", children: [edit, delete])
    }
  }

  private func deleteAction(for indexPath: IndexPath) -> UIAction {
    UIAction(
      title: NSLocalizedString("delete", comment: "Delete action title"),
      attributes: .destructive
    ) { [weak self] _ in
      guard let self else { return }
      let actionSheet = UIAlertController(
        title: "Уверены что хотите удалить трекер?",
        message: nil,
        preferredStyle: .actionSheet
      )

      let cancelAction = UIAlertAction(
        title: NSLocalizedString("cancel", comment: "Cancel action title"),
        style: .cancel
      )
      let deleteAction = UIAlertAction(
        title: NSLocalizedString("delete", comment: "Delete action title"),
        style: .destructive
      ) { [weak self] _ in
        Analytics.reportClick(screen: .main, item: .delete)
        guard let self else { return }
        let cell = collectionView?.cellForItem(at: indexPath) as? TrackerCollectionViewCell
        guard let id = cell?.model?.id else { return }
        try? self.trackerStore.deleteTracker(with: id)
      }

      actionSheet.addAction(cancelAction)
      actionSheet.addAction(deleteAction)
      self.present(actionSheet, animated: true)
    }
  }

  private func editAction(for indexPath: IndexPath) -> UIAction {
    let cell = collectionView?.cellForItem(at: indexPath) as? TrackerCollectionViewCell
    guard let tracker = cell?.model else { return UIAction(title: "") { _ in } }
    let category = categories[indexPath.section]

    return UIAction(title: NSLocalizedString("edit", comment: "Edit action title")) {
      [weak self] _ in
      Analytics.reportClick(screen: .main, item: .edit)
      guard let self else { return }
      let editVC = CreateTrackerViewController(edit: tracker, category: category)
      editVC.delegate = self
      editVC.title = "Создание привычки"

      let navigation = CreateTrackerNavigationController(rootViewController: editVC)
      self.present(navigation, animated: true)
    }
  }

}
