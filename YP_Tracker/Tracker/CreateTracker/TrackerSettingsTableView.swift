import UIKit

final class TrackerSettingsTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
  enum SettingsType {
    case onlyCategory
    case full
  }

  var category: String = "" {
    didSet {
      // updateRow(at: IndexPath(row: 0, section: 0), detail: category)
    }
  }
  var schedule: [String] = [] {
    didSet {
      updateRow(at: IndexPath(row: 1, section: 0), detail: schedule.joined(separator: ", "))
    }
  }

  var didTapCategory: (() -> Void)?
  var didTapSchedule: (() -> Void)?

  private var rows: [(title: String, detail: String)] = [
    ("Категория", ""),
    ("Расписание", ""),
  ]

  init(type: SettingsType = .full) {
    if type == .onlyCategory {
      rows = [("Категория", "")]
    }

    super.init(frame: .zero, style: .plain)
    setupTableView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupTableView() {
    separatorStyle = .singleLine
    separatorColor = .ypGray
    separatorInset = UIEdgeInsets(
      top: 0, left: 16, bottom: 0, right: 16)
    rowHeight = 75
    backgroundColor = .clear
    dataSource = self
    delegate = self
    isScrollEnabled = false
    tableFooterView = UIView(frame: .zero)
    tableHeaderView = UIView(frame: .zero)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rows.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "HabitSettingsCell")

    cell.textLabel?.text = rows[indexPath.row].title
    cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
    cell.textLabel?.textColor = .ypBlack
    cell.accessoryType = .disclosureIndicator
    cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 22)
    cell.selectionStyle = .none
    cell.backgroundColor = .clear
    cell.detailTextLabel?.text = rows[indexPath.row].detail
    cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
    cell.detailTextLabel?.textColor = .ypGray

    cell.layer.cornerRadius = 16
    cell.layer.masksToBounds = true
    cell.layer.backgroundColor = UIColor.ypBackground.cgColor

    return cell
  }

  func tableView(
    _ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath
  ) {
    let totalRows = tableView.numberOfRows(inSection: indexPath.section)
    var maskedCorners: CACornerMask = []

    if indexPath.row == 0 {
      maskedCorners.formUnion([.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    if indexPath.row == totalRows - 1 {
      maskedCorners.formUnion([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
      cell.separatorInset = UIEdgeInsets(
        top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }

    cell.layer.maskedCorners = maskedCorners

  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.row == 0 {
      didTapCategory?()
    } else if indexPath.row == 1 {
      didTapSchedule?()
    }
  }

  private func updateRow(
    at indexPath: IndexPath, detail: String
  ) {
    guard indexPath.row < rows.count else { return }
    rows[indexPath.row].detail = detail
    reloadRows(at: [indexPath], with: .none)
  }

}
