import UIKit

final class TrackerCollectionViewFooter: UICollectionReusableView {
  static let identifier = "TrackerCollectionViewFooter"

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
