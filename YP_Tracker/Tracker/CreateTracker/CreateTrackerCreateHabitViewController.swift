import UIKit

final class CreateTrackerCreateHabitViewController: UIViewController {
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

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  private func setupView() {
    title = "Новая привычка"
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
        equalTo: textFieldContainerView.bottomAnchor),
      habitNameTextFieldErrorLabel.leadingAnchor.constraint(
        equalTo: textFieldContainerView.leadingAnchor),
      habitNameTextFieldErrorLabel.trailingAnchor.constraint(
        equalTo: textFieldContainerView.trailingAnchor),
    ])
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
}
