import UIKit

final class TrackerViewController: UIViewController {
  private var collectionView: UICollectionView?
  var categories: [TrackerCategory] = sampleData
  var completedTrackers: [TrackerRecord] = []
  var selectedDate: Date = Date()

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
    collectionView?.reloadData()
  }

  @objc func leftNavigationItemButtonTapped() {
    let controller = CreateTrackerNavigationController(
      rootViewController: CreateTrackerSelectTypeViewController())
    controller.createTrackerDelegate = self
    controller.modalPresentationStyle = .formSheet
    controller.modalTransitionStyle = .coverVertical
    present(controller, animated: true, completion: nil)
  }
}

extension TrackerViewController: CreateTrackerDelegate {
  func trackerCreated(tracker: Tracker, categoryId: UUID) {
    print("Tracker created: \(tracker.name) in category with id \(categoryId)")
    let categoryIndex = categories.firstIndex(where: { $0.id == categoryId })
    assert(categoryIndex != nil, "Category with id \(categoryId) not found.")
    if let categoryIndex {
      let category = categories[categoryIndex]
      let newCategory = TrackerCategory(
        id: category.id, name: category.name,
        trackers: category.trackers + [tracker])
      categories[categoryIndex] = newCategory
      let section = IndexSet(integer: categoryIndex)
      collectionView?.performBatchUpdates(
        {
          collectionView?.reloadSections(section)
        }, completion: nil)
    }
  }
}

let sampleData: [TrackerCategory] = [
  TrackerCategory(
    id: UUID(), name: "Здоровье",
    trackers: [
      Tracker(id: UUID(), name: "Сон", color: .systemBlue, emoji: "😴", schedule: []),
      Tracker(id: UUID(), name: "Питание", color: .systemGreen, emoji: "🥗", schedule: []),
      Tracker(
        id: UUID(), name: "Физическая активность", color: .systemOrange, emoji: "🏋️", schedule: []
      ),
    ]),
  TrackerCategory(
    id: UUID(), name: "Продуктивность",
    trackers: [
      Tracker(id: UUID(), name: "Работа", color: .systemPurple, emoji: "💼", schedule: []),
      Tracker(id: UUID(), name: "Учеба", color: .systemYellow, emoji: "📚", schedule: []),
    ]),
  TrackerCategory(
    id: UUID(), name: "Хобби",
    trackers: [
      Tracker(id: UUID(), name: "Чтение", color: .systemPink, emoji: "📖", schedule: []),
      Tracker(id: UUID(), name: "Рисование", color: .systemTeal, emoji: "🎨", schedule: []),
    ]),
]
