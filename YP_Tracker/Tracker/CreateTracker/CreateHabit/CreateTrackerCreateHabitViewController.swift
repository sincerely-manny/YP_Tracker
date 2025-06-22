import UIKit

final class CreateTrackerCreateHabitViewController: UIViewController {
  weak var delegate: CreateTrackerDelegate?

  private var schedule: [DayOfWeek] = [] {
    didSet {
      setCreateButtonState()
      if schedule.count == 7 {
        habitSettingsTableView.schedule = ["Каждый день"]
      } else {
        habitSettingsTableView.schedule = schedule.map { $0.titleShort }
      }
    }
  }
  private var categoryId: UUID? = sampleData[0].id

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

  private lazy var habitSettingsTableView: HabitSettingsTableView = {
    let tableView = HabitSettingsTableView()
    tableView.category = sampleData[0].name
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.didTapSchedule = { [weak self] in
      guard let self = self else { return }
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
    button.setTitle("Отмена", for: .normal)
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

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  private func setupView() {
    title = "Новая привычка"
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

    habitSettingsTableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(habitSettingsTableView)
    NSLayoutConstraint.activate([
      habitSettingsTableView.topAnchor.constraint(
        equalTo: textFieldContainerView.bottomAnchor, constant: 16),
      habitSettingsTableView.leadingAnchor.constraint(
        equalTo: view.layoutMarginsGuide.leadingAnchor),
      habitSettingsTableView.trailingAnchor.constraint(
        equalTo: view.layoutMarginsGuide.trailingAnchor),
      habitSettingsTableView.bottomAnchor.constraint(
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
      color: .ypBlue,
      emoji: "🏃",
      schedule: schedule,
    )

    delegate?.trackerCreated(tracker: tracker, categoryId: categoryId ?? UUID())
    dismiss(animated: true)
  }

  private func setCreateButtonState() {
    createButton.isEnabled = !(habitNameTextField.text?.isEmpty ?? true) && schedule.count > 0
    createButton.backgroundColor = createButton.isEnabled ? UIColor.ypBlack : UIColor.ypGray
  }

}

extension CreateTrackerCreateHabitViewController: UITextFieldValidatedErrorDelegate {
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

extension CreateTrackerCreateHabitViewController: ScheduleSelectionViewControllerDelegate {
  func scheduleSelectionViewController(
    _ controller: ScheduleSelectionViewController,
    didSelectDays days: Set<DayOfWeek>
  ) {
    self.schedule = days.sorted { $0.index < $1.index }
  }
}
