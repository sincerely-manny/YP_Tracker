import UIKit

final class CreateTrackerNavigationController: UINavigationController,
  UINavigationControllerDelegate
{
  weak var createTrackerDelegate: CreateTrackerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    view.backgroundColor = .ypWhite
    navigationBar.titleTextAttributes = [
      .foregroundColor: UIColor.ypBlack,
      .font: UIFont.systemFont(ofSize: 16, weight: .medium)
    ]
  }

  func navigationController(
    _ navigationController: UINavigationController,
    willShow viewController: UIViewController,
    animated: Bool
  ) {
    viewController.navigationItem.hidesBackButton = true
  }

}
