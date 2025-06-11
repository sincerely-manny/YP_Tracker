import UIKit

final class TrackerIndexViewController: UIViewController {
  private lazy var leftNavigationItemButton = {
    let button = UIBarButtonItem(
      image: UIImage(
        systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)),
      style: .plain, target: self, action: nil)

    return button
  }()

  private lazy var rightNavigationItemButton = {
    let button = UIButton(type: .system)
    button.setTitle("14.12.22", for: .normal)
    button.layer.cornerRadius = 8
    button.layer.backgroundColor = UIColor(hex: "#F0F0F0")?.cgColor
    button.setTitleColor(
      .ypBlack.appearance(.light), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    button.contentEdgeInsets = UIEdgeInsets(
      top: 6, left: 5.5, bottom: 6, right: 5.5)
    return UIBarButtonItem(customView: button)
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  private func setupView() {
    title = "Трекеры"
    navigationItem.leftBarButtonItem = leftNavigationItemButton
    navigationItem.rightBarButtonItem = rightNavigationItemButton

  }
}
