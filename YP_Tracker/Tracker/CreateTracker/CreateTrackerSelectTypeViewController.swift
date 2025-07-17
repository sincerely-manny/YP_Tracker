import UIKit

final class CreateTrackerSelectTypeViewController: UIViewController {
  private lazy var buttonsContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  private func setupView() {
    title = NSLocalizedString("tracker_creation", comment: "Tracker creation screen title")
    view.backgroundColor = .ypWhite
    view.addSubview(buttonsContainerView)

    NSLayoutConstraint.activate([
      buttonsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      buttonsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      buttonsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
    ])

    setupButtons()
  }

  private func setupButtons() {
    var previousButton: UIButton?
    let buttonHeight: CGFloat = 60
    let spacing: CGFloat = 16

    for type in TrackerType.allCases {
      let button = UIButton(type: .system)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setTitle(type.title, for: .normal)
      button.setTitleColor(.ypWhite, for: .normal)
      button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
      button.backgroundColor = UIColor.ypBlack
      button.layer.cornerRadius = 16
      button.tag = type.rawValue
      button.addTarget(self, action: #selector(trackerTypeSelected(_:)), for: .touchUpInside)
      buttonsContainerView.addSubview(button)

      NSLayoutConstraint.activate([
        button.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor),
        button.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor),
        button.heightAnchor.constraint(equalToConstant: buttonHeight)
      ])

      if let previousButton = previousButton {
        button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: spacing)
          .isActive = true
      } else {
        button.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor).isActive = true
      }
      previousButton = button
    }

    if let lastButton = previousButton {
      lastButton.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor).isActive = true
    }
  }

  @objc private func trackerTypeSelected(_ sender: UIButton) {
    assert(sender.tag < TrackerType.allCases.count, "Invalid tracker type selected")
    let trackerType = TrackerType.allCases[sender.tag]
    let vc = CreateTrackerViewController(trackerType: trackerType)
    if let navigationController = navigationController as? CreateTrackerNavigationController,
      let createTrackerDelegate = navigationController.createTrackerDelegate
    {
      vc.delegate = createTrackerDelegate
    } else {
      assertionFailure(
        "NavigationController is not of type CreateTrackerNavigationController or delegate is nil"
      )
    }
    navigationController?.pushViewController(vc, animated: true)

  }
}
