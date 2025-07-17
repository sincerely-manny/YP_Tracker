import UIKit

enum FilterType: Int, CaseIterable {
  case all = 0
  case today = 1
  case completed = 2
  case notCompleted = 3

  var title: String {
    switch self {
    case .all:
      return "Все трекеры"
    case .today:
      return "Трекеры на сегодня"
    case .completed:
      return "Завершенные"
    case .notCompleted:
      return "Не завершенные"
    }
  }
}

final class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  var onFilterSelected: ((FilterType) -> Void)?
  var selectedFilter: FilterType?
  let dataSource: [FilterType] = FilterType.allCases

  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
    tableView.dataSource = self
    tableView.delegate = self

    tableView.backgroundColor = .clear
    tableView.rowHeight = 75
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  init(selectedFilter: FilterType? = nil, onFilterSelected: ((FilterType) -> Void)? = nil) {
    self.onFilterSelected = onFilterSelected
    self.selectedFilter = selectedFilter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    dataSource.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "FilterCell")
    cell.textLabel?.text = dataSource[indexPath.row].title
    cell.selectionStyle = .none
    cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    cell.textLabel?.textColor = .ypBlack
    cell.backgroundColor = .ypBackground
    cell.layer.cornerRadius = 16
    cell.accessoryType =
      selectedFilter == dataSource[indexPath.row]
        && selectedFilter != .all
        && selectedFilter != .today
      ? .checkmark : .none

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selected = dataSource[indexPath.row]
    selectedFilter = selected
    onFilterSelected?(selected)

    dismiss(animated: true, completion: nil)
  }
}
