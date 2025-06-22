import UIKit

final class TrackerCollectionView: UICollectionView {
  private let flowLayout = UICollectionViewFlowLayout()

  init(dataSource: UICollectionViewDataSource) {
    super.init(frame: .zero, collectionViewLayout: flowLayout)

    self.dataSource = dataSource
    register(
      TrackerCollectionViewCell.self,
      forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)

    register(
      TrackerCollectionViewHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: TrackerCollectionViewHeader.identifier)

    register(
      TrackerCollectionViewFooter.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: TrackerCollectionViewFooter.identifier)

    setup()

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    updateLayoutItemSizes()
  }

  private func updateLayoutItemSizes() {
    let horizontalMargin = layoutMargins.left + layoutMargins.right
    let availableWidth = bounds.width - horizontalMargin

    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 0
    flowLayout.itemSize = CGSize(width: (availableWidth - 10) / 2, height: 148)
    flowLayout.headerReferenceSize = CGSize(width: bounds.width, height: 30)
    flowLayout.footerReferenceSize = CGSize(width: bounds.width, height: 16)
    flowLayout.sectionInset = UIEdgeInsets(
      top: 0, left: layoutMargins.left, bottom: 0, right: layoutMargins.right)
  }

  private func setup() {
    let emptyPlaceholder = TrackerEmptyListPlaceholder()
    backgroundColor = .clear
    backgroundView = emptyPlaceholder
    guard let backgroundView = backgroundView else { return }
    backgroundView.frame = bounds
    backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
}
