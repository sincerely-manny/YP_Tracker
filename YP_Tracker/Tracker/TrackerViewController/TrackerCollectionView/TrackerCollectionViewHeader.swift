import UIKit

final class TrackerCollectionViewHeader: UICollectionReusableView {
  static let identifier = "TrackerCollectionViewHeader"

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
    label.textColor = UIColor.ypBlack
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
      titleLabel.topAnchor.constraint(equalTo: topAnchor)
    ])
  }

  func configure(with title: String) {
    titleLabel.text = title
  }
}
