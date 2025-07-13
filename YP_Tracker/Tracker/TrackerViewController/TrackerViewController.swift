import UIKit

final class TrackerViewController: UIViewController {
  var collectionView: UICollectionView?

  var selectedDate: Date = Date()
  let trackerStore: TrackerStore = DataProvider.shared.trackerStore
  let recordStore: TrackerRecordStore = DataProvider.shared.trackerRecordStore
  let trackerCategoryStore: TrackerCategoryStore = DataProvider.shared.trackerCategoryStore

  var categories: [TrackerCategory] = [] {
    didSet { setFilteredTrackers() }
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
    return datePicker
  }()
  private lazy var rightNavigationItemButton: UIBarButtonItem = {
    UIBarButtonItem(customView: datePicker)
  }()

  private lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "Поиск"
    searchBar.searchTextField.layer.cornerRadius = 8
    searchBar.searchTextField.layer.masksToBounds = true
    searchBar.backgroundImage = UIImage()
    return searchBar
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    trackerStore.delegate = self
    recordStore.delegate = self
    trackerCategoryStore.delegate = self
    categories = trackerCategoryStore.fetchCategories()
    trackerRecords = recordStore.allRecords()
    setFilteredTrackers()
    setupView()
  }

  private func setupView() {
    title = "Трекеры"
    navigationItem.leftBarButtonItem = leftNavigationItemButton
    navigationItem.rightBarButtonItem = rightNavigationItemButton

    view.addSubview(searchBar)

    searchBar.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      searchBar.leadingAnchor.constraint(
        equalTo: view.layoutMarginsGuide.leadingAnchor, constant: -8),
      searchBar.trailingAnchor.constraint(
        equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 8),
    ])

    collectionView = TrackerCollectionView(dataSource: self)
    guard let collectionView else {
      assertionFailure("CollectionView is nil")
      return
    }
    view.addSubview(collectionView)

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.layoutMargins = UIEdgeInsets(
      top: 0, left: 16, bottom: 0, right: 16)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      collectionView.leadingAnchor.constraint(
        equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(
        equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])

  }

  @objc func datePickerValueChanged(_ sender: UIDatePicker) {
    selectedDate = sender.date
    setFilteredTrackers()
  }

  @objc func leftNavigationItemButtonTapped() {
    let controller = CreateTrackerNavigationController(
      rootViewController: CreateTrackerSelectTypeViewController())
    controller.createTrackerDelegate = self

    controller.modalPresentationStyle = .formSheet
    controller.modalTransitionStyle = .coverVertical
    present(controller, animated: true, completion: nil)
  }

  private func setFilteredTrackers() {
    var filtered: [TrackerCategory] = []
    let selectedDayOfWeek = Calendar.current.component(.weekday, from: selectedDate)
    for category in categories {
      let filteredTrackers = category.trackers.filter { tracker in
        if let schedule = tracker.schedule {
          return schedule.contains { $0.rawValue == selectedDayOfWeek }
        } else {
          return true
        }
      }
      if !filteredTrackers.isEmpty {
        filtered.append(
          TrackerCategory(
            id: category.id, name: category.name, trackers: filteredTrackers))
      }
    }
    filteredTrackers = filtered
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
}
