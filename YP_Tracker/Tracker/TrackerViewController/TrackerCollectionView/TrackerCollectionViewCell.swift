import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
  static let identifier = "TrackerCollectionViewCell"
  private var model: Tracker? = nil
  weak var delegate: TrackerCollectionViewCellDelegate?

  var isCompleted: Bool = false {
    didSet {
      plusButton.isCompleted = isCompleted
    }
  }
  var trackerCompletedTimes: Int = 0 {
    didSet {
      var d = "дней"
      if trackerCompletedTimes % 10 == 1 && trackerCompletedTimes % 100 != 11 {
        d = "день"
      } else if (trackerCompletedTimes % 10 >= 2 && trackerCompletedTimes % 10 <= 4)
        && !(trackerCompletedTimes % 100 >= 12 && trackerCompletedTimes % 100 <= 14)
      {
        d = "дня"
      }
      progressLabel.text = "\(trackerCompletedTimes) \(d)"
    }
  }

  private lazy var emojiLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = UIColor.white.withAlphaComponent(0.3)
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    label.layer.cornerRadius = 12
    label.clipsToBounds = true
    label.textAlignment = .center
    return label
  }()

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    label.textColor = UIColor.ypWhite.appearance(.light)
    label.numberOfLines = 0
    return label
  }()

  private lazy var header: UIView = {
    let header = UIView()
    header.translatesAutoresizingMaskIntoConstraints = false
    header.layer.cornerRadius = 16
    header.clipsToBounds = true
    header.addSubview(emojiLabel)
    NSLayoutConstraint.activate([
      emojiLabel.widthAnchor.constraint(equalToConstant: 24),
      emojiLabel.heightAnchor.constraint(equalToConstant: 24),
      emojiLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 12),
      emojiLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 12)
    ])
    header.addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 12),
      titleLabel.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -12),
      titleLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -12)
    ])

    return header
  }()

  private lazy var plusButton: TrackerCollectionViewCellPlusButton = {
    let button = TrackerCollectionViewCellPlusButton()
    button.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
    return button
  }()

  private lazy var progressLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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

  func setup() {
    contentView.addSubview(header)
    NSLayoutConstraint.activate([
      header.topAnchor.constraint(equalTo: contentView.topAnchor),
      header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      header.heightAnchor.constraint(equalToConstant: 90)
    ])

    contentView.addSubview(plusButton)
    NSLayoutConstraint.activate([
      plusButton.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 8),
      plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
      plusButton.widthAnchor.constraint(equalToConstant: 34),
      plusButton.heightAnchor.constraint(equalToConstant: 34)
    ])

    contentView.addSubview(progressLabel)
    NSLayoutConstraint.activate([
      progressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      progressLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
      progressLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor)
    ])

  }

  func configure(with model: Tracker) {
    self.model = model
    header.backgroundColor = UIColor.init(hex: model.color)
    emojiLabel.text = model.emoji
    titleLabel.text = model.name
    plusButton.color = UIColor.init(hex: model.color) ?? UIColor.clear
  }

  @objc private func completionButtonTapped() {
    guard let tracker = model else { return }
    delegate?.didTapCompletionButton(for: tracker, with: self)
  }
}
