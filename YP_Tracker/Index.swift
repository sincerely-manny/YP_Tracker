import UIKit

final class IndexTabbarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  private func setup() {
    view.backgroundColor = .ypWhite
    let tracker = TrackerNavigationController()
    tracker.tabBarItem = UITabBarItem(
      title: nil, image: UIImage(named: "tracker_tabbar_item"), tag: 0)

    let statistics = StatisticsViewController()
    statistics.tabBarItem = UITabBarItem(
      title: "Statistics", image: UIImage(named: "statistics_tabbar_item"), tag: 1)

    viewControllers = [tracker, statistics]

    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .ypWhite
    appearance.shadowColor = UIColor.black.withAlphaComponent(0.3)
    appearance.stackedLayoutAppearance.selected.iconColor = .accent
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
      .foregroundColor: UIColor.accent
    ]
    appearance.stackedLayoutAppearance.normal.iconColor = .ypGray
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
      .foregroundColor: UIColor.ypGray
    ]
    tabBar.standardAppearance = appearance
    if #available(iOS 15.0, *) {
      tabBar.scrollEdgeAppearance = appearance
    }
  }
}
