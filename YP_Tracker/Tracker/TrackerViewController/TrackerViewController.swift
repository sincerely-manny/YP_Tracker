import UIKit

final class TrackerViewController: UIViewController {
  private var collectionView: UICollectionView?
  var completedTrackers: [TrackerRecord] = []
  var selectedDate: Date = Date()
  let dataProvider = DataProvider.shared

  var categories: [TrackerCategory] = DataProvider.shared.fetchCategories() {
    didSet { setFilteredTrackers() }
  }
  var filteredTrackers: [TrackerCategory] = [] {
    didSet { collectionView?.reloadData() }
  }

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
    // let categoryIndex = categories.firstIndex(where: { $0.id == categoryId })
    // assert(categoryIndex != nil, "Category with id \(categoryId) not found.")
    // if let categoryIndex {
    //   let category = categories[categoryIndex]
    //   // let newCategory = TrackerCategory(
    //   //   id: category.id, name: category.name,
    //   //   trackers: category.trackers + [tracker])
    //   // categories[categoryIndex] = newCategory
    //   let section = IndexSet(integer: categoryIndex)
    //   collectionView?.performBatchUpdates(
    //     {
    //       collectionView?.reloadSections(section)
    //     }, completion: nil)
    // }
    do {
      try dataProvider.createTracker(tracker: tracker, categoryId: categoryId)
      categories = dataProvider.fetchCategories()
    } catch {
      assertionFailure("Failed to create tracker: \(error)")
    }

  }
}
