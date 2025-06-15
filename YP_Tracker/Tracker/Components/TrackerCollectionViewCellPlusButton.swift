import UIKit

final class TrackerCollectionViewCellPlusButton: UIButton {
  private let feebback = UIImpactFeedbackGenerator(style: .light)

  var isCompleted: Bool = false {
    didSet {
      setImage(isCompleted ? checkImage : plusImage, for: .normal)
      backgroundColor = isCompleted ? color.withAlphaComponent(0.3) : color.withAlphaComponent(1)
    }
  }

  var color: UIColor = .clear {
    didSet {
      backgroundColor = isCompleted ? color.withAlphaComponent(0.3) : color.withAlphaComponent(1)
    }
  }

  private lazy var plusImage: UIImage? = {
    UIImage(
      systemName: "plus",
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold))
  }()
  private lazy var checkImage: UIImage? = {
    UIImage(
      systemName: "checkmark",
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold))
  }()

  init() {
    super.init(frame: .zero)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    setImage(plusImage, for: .normal)
    tintColor = .ypWhite.appearance(.light)
    layer.cornerRadius = 17
    addTarget(self, action: #selector(buttonTapped), for: .touchDown)
    translatesAutoresizingMaskIntoConstraints = false
  }

  @objc private func buttonTapped() {
    feebback.impactOccurred()
  }

}
