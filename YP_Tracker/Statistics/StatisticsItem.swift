import UIKit

final class StatisticsItem: UIView {
  var count: Int = 0 {
    didSet {
      updateUI()
    }
  }

  var title: String = ""

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(title: String) {
    self.title = title
    super.init(frame: .zero)
    setupView()
  }

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = title
    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    label.textColor = .ypBlack
    label.textAlignment = .left
    return label
  }()

  private lazy var countLabel: UILabel = {
    let label = UILabel()
    label.text = String(count)
    label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
    label.textColor = .ypBlack
    label.textAlignment = .left
    return label
  }()

  private func setupView() {
    layer.cornerRadius = 16
    clipsToBounds = true
    layer.masksToBounds = true

    let borderView = UIImageView(image: UIImage(resource: .statsBorderGradient))

    borderView.contentMode = .scaleAspectFill
    borderView.frame = bounds
    borderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(borderView)

    let backgroundView = UIView()
    backgroundView.backgroundColor = .ypWhite
    backgroundView.layer.cornerRadius = 15
    backgroundView.clipsToBounds = true
    backgroundView.layer.masksToBounds = true
    addSubview(backgroundView)

    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
      backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
      backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1),
      backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
    ])

    borderView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      borderView.topAnchor.constraint(equalTo: topAnchor),
      borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
      borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
      borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])

    addSubview(titleLabel)
    addSubview(countLabel)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    countLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),

      countLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      countLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
    ])

  }

  private func updateUI() {
    countLabel.text = String(count)
    titleLabel.text = title
  }
}
