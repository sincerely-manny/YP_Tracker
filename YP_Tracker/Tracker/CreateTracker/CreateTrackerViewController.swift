import UIKit

final class CreateTrackerViewController: UIViewController {
  weak var delegate: CreateTrackerDelegate?

  var trackerType: TrackerType = .habit

  private var schedule: [DayOfWeek] = [] {
    didSet {
      setCreateButtonState()
      if schedule.count == 7 {
        trackerSettingsTableView.schedule = ["Каждый день"]
      } else {
        trackerSettingsTableView.schedule = schedule.map { $0.titleShort }
      }
    }
  }
  private var categoryId: UUID = sampleData[0].id

  private lazy var textFieldContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var habitNameTextField: UITextField = {
    let textField = UITextFieldValidated()
    textField.placeholder = "Введите название трекера"
    textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    textField.textColor = UIColor.ypBlack
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.clearButtonMode = .whileEditing
    textField.returnKeyType = .done
    textField.maxLength = 38
    textField.errorDelegate = self
    textField.dismissKeyboardOnReturn = true
    return textField
  }()

  private lazy var habitNameTextFieldErrorLabel: UILabel = {
    let label = UILabel()
    label.text = "Ограничение 38 символов"
    label.textColor = UIColor.ypRed
    label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.isHidden = true
    label.textAlignment = .center
    return label
  }()

  private lazy var trackerSettingsTableView: TrackerSettingsTableView = {
    let tableView = TrackerSettingsTableView(type: trackerType == .habit ? .full : .onlyCategory)
    tableView.category = sampleData[0].name
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.didTapSchedule = { [weak self] in
      guard let self else { return }
      let vc = ScheduleSelectionViewController(selectedDays: Set(self.schedule))
      vc.delegate = self
      self.navigationController?.pushViewController(
        vc, animated: true)
    }
    return tableView
  }()

  private lazy var bottomButtonsContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var cancelButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Отменить", for: .normal)
    button.setTitleColor(.ypRed, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    button.backgroundColor = .clear
    button.layer.cornerRadius = 16
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.ypRed.cgColor
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    return button
  }()

  private lazy var createButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Создать", for: .normal)
    button.setTitleColor(.ypWhite, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    button.backgroundColor = UIColor.ypGray
    button.isEnabled = false
    button.layer.cornerRadius = 16
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    return button
  }()

  init(trackerType: TrackerType = .habit) {
    self.trackerType = trackerType
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
    title = trackerType.title
    view.backgroundColor = .ypWhite
    view.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)

    view.addSubview(textFieldContainerView)

    NSLayoutConstraint.activate([
      textFieldContainerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      textFieldContainerView.leadingAnchor.constraint(
        equalTo: view.layoutMarginsGuide.leadingAnchor),
      textFieldContainerView.trailingAnchor.constraint(
        equalTo: view.layoutMarginsGuide.trailingAnchor),
      textFieldContainerView.heightAnchor.constraint(equalToConstant: 75),
    ])

    textFieldContainerView.addSubview(habitNameTextField)

    NSLayoutConstraint.activate([
      habitNameTextField.centerYAnchor.constraint(equalTo: textFieldContainerView.centerYAnchor),
      habitNameTextField.leadingAnchor.constraint(
        equalTo: textFieldContainerView.leadingAnchor, constant: 16),
      habitNameTextField.trailingAnchor.constraint(
        equalTo: textFieldContainerView.trailingAnchor, constant: -16),
      habitNameTextField.heightAnchor.constraint(equalToConstant: 44),
    ])

    textFieldContainerView.addSubview(habitNameTextFieldErrorLabel)

    NSLayoutConstraint.activate([
      habitNameTextFieldErrorLabel.bottomAnchor.constraint(
        equalTo: textFieldContainerView.bottomAnchor, constant: -8),
      habitNameTextFieldErrorLabel.leadingAnchor.constraint(
        equalTo: textFieldContainerView.leadingAnchor),
      habitNameTextFieldErrorLabel.trailingAnchor.constraint(
        equalTo: textFieldContainerView.trailingAnchor),
    ])

    trackerSettingsTableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(trackerSettingsTableView)
    NSLayoutConstraint.activate([
      trackerSettingsTableView.topAnchor.constraint(
        equalTo: textFieldContainerView.bottomAnchor, constant: 16),
      trackerSettingsTableView.leadingAnchor.constraint(
        equalTo: view.layoutMarginsGuide.leadingAnchor),
      trackerSettingsTableView.trailingAnchor.constraint(
        equalTo: view.layoutMarginsGuide.trailingAnchor),
      trackerSettingsTableView.bottomAnchor.constraint(
        equalTo: view.layoutMarginsGuide.bottomAnchor),
    ])

    view.addSubview(bottomButtonsContainerView)
    NSLayoutConstraint.activate([
      bottomButtonsContainerView.leadingAnchor.constraint(
        equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 4),
      bottomButtonsContainerView.trailingAnchor.constraint(
        equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -4),
      bottomButtonsContainerView.bottomAnchor.constraint(
        equalTo: view.keyboardLayoutGuide.topAnchor, constant: -16),
      bottomButtonsContainerView.heightAnchor.constraint(equalToConstant: 60),
    ])

    bottomButtonsContainerView.addSubview(cancelButton)
    NSLayoutConstraint.activate([
      cancelButton.leadingAnchor.constraint(
        equalTo: bottomButtonsContainerView.leadingAnchor),
      cancelButton.trailingAnchor.constraint(
        equalTo: bottomButtonsContainerView.centerXAnchor, constant: -4),
      cancelButton.topAnchor.constraint(
        equalTo: bottomButtonsContainerView.topAnchor),
      cancelButton.bottomAnchor.constraint(
        equalTo: bottomButtonsContainerView.bottomAnchor),
    ])

    bottomButtonsContainerView.addSubview(createButton)
    NSLayoutConstraint.activate([
      createButton.leadingAnchor.constraint(
        equalTo: bottomButtonsContainerView.centerXAnchor, constant: 4),
      createButton.trailingAnchor.constraint(
        equalTo: bottomButtonsContainerView.trailingAnchor),
      createButton.topAnchor.constraint(
        equalTo: bottomButtonsContainerView.topAnchor),
      createButton.bottomAnchor.constraint(
        equalTo: bottomButtonsContainerView.bottomAnchor),
    ])

  }

  @objc private func cancelButtonTapped() {
    dismiss(animated: true)
  }

  @objc private func createButtonTapped() {
    guard let habitName = habitNameTextField.text, !habitName.isEmpty else { return }
    let tracker = Tracker(
      id: UUID(),
      name: habitName,
      color: [
        .systemRed, .systemGreen, .systemBlue, .systemOrange, .systemPurple, .systemYellow,
        .systemPink, .systemTeal, .systemIndigo,
      ].randomElement() ?? .systemGray,
      emoji: ["🏃", "🍎", "💧", "🧘", "📚", "🎨"].randomElement() ?? "✅",
      schedule: schedule.isEmpty ? nil : schedule,
    )
    assert(delegate != nil, "Delegate must be set before creating a tracker")
    delegate?.trackerCreated(tracker: tracker, categoryId: categoryId)
    dismiss(animated: true)
  }

  private func setCreateButtonState() {
    if trackerType == .irregularEvent {
      createButton.isEnabled = !(habitNameTextField.text?.isEmpty ?? true)
    } else {
      createButton.isEnabled = !(habitNameTextField.text?.isEmpty ?? true) && schedule.count > 0
    }

    createButton.backgroundColor = createButton.isEnabled ? UIColor.ypBlack : UIColor.ypGray
  }

}

extension CreateTrackerViewController: UITextFieldValidatedErrorDelegate {
  func textFieldDidAddError(
    _ textField: UITextFieldValidated, error: UITextFieldValidated.ErrorType
  ) {
    if error == .overMaxLength {
      habitNameTextFieldErrorLabel.isHidden = false
    }
  }

  func textFieldDidRemoveError(
    _ textField: UITextFieldValidated, error: UITextFieldValidated.ErrorType
  ) {
    if error == .overMaxLength {
      habitNameTextFieldErrorLabel.isHidden = true
    }
  }

  func textFieldDidChange(
    _ textField: UITextFieldValidated, newValue: String?
  ) {
    setCreateButtonState()
  }

}

extension CreateTrackerViewController: ScheduleSelectionViewControllerDelegate {
  func scheduleSelectionViewController(
    _ controller: ScheduleSelectionViewController,
    didSelectDays days: Set<DayOfWeek>
  ) {
    self.schedule = days.sorted { day1, day2 in
      let order1 = day1 == .sun ? 8 : day1.rawValue
      let order2 = day2 == .sun ? 8 : day2.rawValue
      return order1 < order2
    }
  }
}
