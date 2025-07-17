import UIKit

final class TrackerViewController: UIViewController {
  var collectionView: UICollectionView?

  var selectedDate: Date = Date()
  let trackerStore: TrackerStore = DataProvider.shared.trackerStore
  let recordStore: TrackerRecordStore = DataProvider.shared.trackerRecordStore
  let trackerCategoryStore: TrackerCategoryStore = DataProvider.shared.trackerCategoryStore

  private static let filterTypeKey = "TrackerViewController.filterType"

  var categories: [TrackerCategory] = [] {
    didSet { setFilteredTrackers() }
  }
  var searchQuery: String = "" {
    didSet { setFilteredTrackers() }
  }
  var filterType: FilterType =
    UserDefaults.standard.object(forKey: filterTypeKey) != nil
    ? FilterType(rawValue: UserDefaults.standard.integer(forKey: filterTypeKey)) ?? .all : .all
  {
    didSet {
      UserDefaults.standard.set(filterType.rawValue, forKey: Self.filterTypeKey)
      if filterType != .all && filterType != .today {
        filterButtonBadge.isHidden = false
      } else {
        filterButtonBadge.isHidden = true
      }
      setFilteredTrackers()
    }
  }
  var filteredTrackers: [TrackerCategory] = [] {
    didSet { collectionView?.reloadData() }
  }

  var trackerRecords: [TrackerRecord] = []

  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter
  }()

  private lazy var leftNavigationItemButton: UIBarButtonItem = {
    let button = UIBarButtonItem(
      image: UIImage(
        systemName: "plus",
        withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)),
      style: .plain, target: self, action: nil)

    button.action = #selector(leftNavigationItemButtonTapped)

    return button
  }()

  private lazy var datePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .compact
    datePicker.tintColor = UIColor.systemBlue
    datePicker.date = selectedDate
    datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    datePicker.backgroundColor = .ypWhite.appearance(.light)
    datePicker.layer.cornerRadius = 8
    datePicker.clipsToBounds = true
    datePicker.layer.masksToBounds = true
    datePicker.overrideUserInterfaceStyle = .light

    return datePicker
  }()
  private lazy var rightNavigationItemButton: UIBarButtonItem = {
    UIBarButtonItem(customView: datePicker)
  }()

  private lazy var searchBar: UISearchTextField = {
    let searchBar = UISearchTextField()
    searchBar.placeholder = NSLocalizedString(
      "search", comment: "Placeholder text for search bar")
    searchBar.addTarget(self, action: #selector(searchBarTextDidChange(_:)), for: .editingChanged)
    return searchBar
  }()

  private lazy var filterButton: UIButton = {
    let button = UIButton(type: .system)
    let title = NSLocalizedString(
      "filters", comment: "Title for filter button")
    button.setTitle(title, for: .normal)
    button.setTitleColor(.ypWhite.appearance(.light), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
    button.backgroundColor = .ypBlue
    button.layer.cornerRadius = 16
    button.clipsToBounds = true
    button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false

    button.addSubview(filterButtonBadge)

    NSLayoutConstraint.activate([
      filterButtonBadge.widthAnchor.constraint(equalToConstant: 8),
      filterButtonBadge.heightAnchor.constraint(equalToConstant: 8),
      filterButtonBadge.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -8),
      filterButtonBadge.topAnchor.constraint(equalTo: button.topAnchor, constant: 8),
    ])
    if filterType != .all && filterType != .today {
      filterButtonBadge.isHidden = false
    } else {
      filterButtonBadge.isHidden = true
    }

    return button
  }()

  private lazy var filterButtonBadge: UIView = {
    let badgeView = UIView()
    badgeView.backgroundColor = .ypRed
    badgeView.layer.cornerRadius = 4
    badgeView.clipsToBounds = true
    badgeView.translatesAutoresizingMaskIntoConstraints = false

    return badgeView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    Analytics.reportOpen(screen: .main)
    trackerStore.delegate = self
    recordStore.delegate = self
    trackerCategoryStore.delegate = self
    categories = trackerCategoryStore.fetchCategories()
    trackerRecords = recordStore.allRecords()
    setFilteredTrackers()
    setupView()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    Analytics.reportClose(screen: .main)
  }

  private func setupView() {
    title = NSLocalizedString(
      "trackers", comment: "Trackers list title")
    navigationItem.leftBarButtonItem = leftNavigationItemButton
    navigationItem.rightBarButtonItem = rightNavigationItemButton

    view.addSubview(searchBar)

    searchBar.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      searchBar.leadingAnchor.constraint(
        equalTo: view.layoutMarginsGuide.leadingAnchor),
      searchBar.trailingAnchor.constraint(
        equalTo: view.layoutMarginsGuide.trailingAnchor),
      searchBar.heightAnchor.constraint(equalToConstant: 36),
    ])

    collectionView = TrackerCollectionView(dataSource: self, delegate: self)
    guard let collectionView else {
      assertionFailure("CollectionView is nil")
      return
    }
    view.addSubview(collectionView)

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.layoutMargins = UIEdgeInsets(
      top: 0, left: 16, bottom: 0, right: 16)
    collectionView.contentInset.top = 34
    collectionView.contentInset.bottom = 82
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      collectionView.leadingAnchor.constraint(
        equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(
        equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])

    view.addSubview(filterButton)
    NSLayoutConstraint.activate([
      filterButton.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      filterButton.heightAnchor.constraint(equalToConstant: 50),
      filterButton.widthAnchor.constraint(equalToConstant: 114),
    ])

  }

  @objc func datePickerValueChanged(_ sender: UIDatePicker) {
    selectedDate = sender.date
    setFilteredTrackers()
  }

  @objc func leftNavigationItemButtonTapped() {
    Analytics.reportClick(screen: .main, item: .add_track)
    let controller = CreateTrackerNavigationController(
      rootViewController: CreateTrackerSelectTypeViewController())
    controller.createTrackerDelegate = self

    controller.modalPresentationStyle = .formSheet
    controller.modalTransitionStyle = .coverVertical
    present(controller, animated: true, completion: nil)
  }

  @objc func searchBarTextDidChange(_ sender: UISearchTextField) {
    searchQuery = sender.text ?? ""
  }

  @objc func filterButtonTapped() {
    Analytics.reportClick(screen: .main, item: .filter)
    let viewController = FiltersViewController(selectedFilter: filterType) {
      [weak self] filterType in
      if filterType == .today {
        self?.selectedDate = Date()
        self?.datePicker.date = Date()
      }

      self?.filterType = filterType
    }
    viewController.title = NSLocalizedString(
      "filters", comment: "Title for filter view")

    let navigation = CreateTrackerNavigationController(rootViewController: viewController)
    navigation.modalPresentationStyle = .formSheet
    navigation.modalTransitionStyle = .coverVertical

    present(navigation, animated: true, completion: nil)

  }

  private func setFilteredTrackers() {
    var filtered: [TrackerCategory] = []
    let selectedDayOfWeek = Calendar.current.component(.weekday, from: selectedDate)
    var trackersOnDateCount = 0
    for category in categories {
      let filteredTrackers = category.trackers.filter { tracker in
        if let schedule = tracker.schedule,
          !schedule.contains(where: { $0.rawValue == selectedDayOfWeek })
        {
          return false
        }
        trackersOnDateCount += 1

        guard searchQuery.isEmpty || tracker.name.localizedCaseInsensitiveContains(searchQuery)
        else {
          return false
        }

        let isCompleted = tracker.records.contains {
          Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
        switch (filterType, isCompleted) {
        case (.all, _), (.today, _):
          return true
        case (.completed, let isCompleted):
          return isCompleted
        case (.notCompleted, let isCompleted):
          return !isCompleted
        }
      }
      if !filteredTrackers.isEmpty {
        filtered.append(
          TrackerCategory(
            id: category.id, name: category.name, trackers: filteredTrackers))
      }
    }
    filteredTrackers = filtered
    if trackersOnDateCount == 0 {
      filterButton.isHidden = true
    } else {
      filterButton.isHidden = false
    }
  }
}

extension TrackerViewController: CreateTrackerDelegate {
  func trackerCreated(tracker: TrackerCreateDTO, categoryId: Identifier) {
    do {
      try trackerStore.createTracker(with: tracker, categoryId: categoryId)
    } catch {
      assertionFailure("Failed to create tracker: \(error)")
    }
  }

  func trackerUpdated(tracker: Tracker, categoryId: Identifier) {
    do {
      try trackerStore.updateTracker(with: tracker, categoryId: categoryId)
    } catch {
      assertionFailure("Failed to update tracker: \(error)")
    }
  }

}
