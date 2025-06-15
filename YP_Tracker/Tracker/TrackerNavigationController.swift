import UIKit

final class TrackerNavigationController: UINavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  private func setup() {
    let index = TrackerViewController()
    self.setViewControllers([index], animated: true)

    navigationBar.prefersLargeTitles = true
    navigationBar.tintColor = .ypBlack
    navigationBar.largeTitleTextAttributes = [
      .foregroundColor: UIColor.ypBlack,
      .font: UIFont.systemFont(ofSize: 34, weight: .bold),
    ]
  }

}
