import UIKit

final class ScheduleSelectionViewController: UIViewController {
  let tableData: [DayOfWeek] = DayOfWeek.allCases
  var selectedDays: Set<DayOfWeek> = []

  weak var delegate: ScheduleSelectionViewControllerDelegate?

  private lazy var scheduleTableView: UITableView = {
    let tableView = UITableView()
    tableView.rowHeight = 75
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = .ypGray
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()

  private lazy var doneButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Готово", for: .normal)
    button.setTitleColor(.ypWhite, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    button.backgroundColor = UIColor.ypBlack
    button.layer.cornerRadius = 16
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    return button
  }()

  init(selectedDays: Set<DayOfWeek> = []) {
    self.selectedDays = selectedDays
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  private func setupView() {
    title = "Расписание"
    view.backgroundColor = .ypWhite

    view.addSubview(doneButton)
    NSLayoutConstraint.activate([
      doneButton.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      doneButton.heightAnchor.constraint(equalToConstant: 60),
    ])

    view.addSubview(scheduleTableView)

    NSLayoutConstraint.activate([
      scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scheduleTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -16),
    ])
  }

  @objc private func switchValueChanged(_ sender: UISwitch) {
    guard let cell = sender.superview as? UITableViewCell,
      let indexPath = scheduleTableView.indexPath(for: cell)
    else { return }
    cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
    cell.textLabel?.textColor = .ypBlack
    let day = tableData[indexPath.row]

    if sender.isOn {
      selectedDays.insert(day)
    } else {
      selectedDays.remove(day)
    }
  }

  @objc private func doneButtonTapped() {
    delegate?.scheduleSelectionViewController(self, didSelectDays: selectedDays)
    navigationController?.popViewController(animated: true)
  }

}

extension ScheduleSelectionViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "ScheduleCell")

    let day = tableData[indexPath.row]
    cell.textLabel?.text = day.titleFull
    let switchView = UISwitch(frame: .zero)
    switchView.onTintColor = .ypBlue
    switchView.isOn = selectedDays.contains(day)
    switchView.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    cell.accessoryView = switchView
    return cell
  }

  func tableView(
    _ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath
  ) {
    if indexPath.row == tableData.count - 1 {
      cell.separatorInset = UIEdgeInsets(
        top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }
  }

  func tableView(
    _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
  ) {
    if let cell = tableView.cellForRow(at: indexPath),
      let switchView = cell.accessoryView as? UISwitch
    {
      switchView.setOn(!switchView.isOn, animated: true)
      switchValueChanged(switchView)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

protocol ScheduleSelectionViewControllerDelegate: AnyObject {
  func scheduleSelectionViewController(
    _ controller: ScheduleSelectionViewController,
    didSelectDays days: Set<DayOfWeek>
  )
}
