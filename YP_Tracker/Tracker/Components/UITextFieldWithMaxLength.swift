import UIKit

final class UITextFieldValidated: UITextField, UITextFieldDelegate {
  enum ErrorType {
    case overMaxLength
  }
  var maxLength: Int? = nil
  var dismissKeyboardOnReturn: Bool = false
  weak var errorDelegate: UITextFieldValidatedErrorDelegate?

  private var errors: Set<ErrorType> = []

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.delegate = self
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.delegate = self
  }

  func textField(
    _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    guard let currentText = textField.text else { return true }
    guard let maxLength else { return true }
    let newLength = currentText.count + string.count - range.length
    if newLength <= maxLength {
      removeError(.overMaxLength)
      return true
    } else {
      addError(.overMaxLength)
      return false
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let maxLength = maxLength else { return }
    if let text = textField.text, text.count > maxLength {
      addError(.overMaxLength)
    } else {
      removeError(.overMaxLength)
    }
  }

  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    removeError(.overMaxLength)
    return true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if dismissKeyboardOnReturn {
      textField.resignFirstResponder()
    }
    return true
  }

  private func addError(_ error: ErrorType) {
    if !errors.contains(error) {
      errors.insert(error)
      errorDelegate?.textFieldDidAddError(self, error: error)
    }
  }

  private func removeError(_ error: ErrorType) {
    if errors.contains(error) {
      errors.remove(error)
      errorDelegate?.textFieldDidRemoveError(self, error: error)
    }
  }

}

protocol UITextFieldValidatedErrorDelegate: AnyObject {
  func textFieldDidAddError(
    _ textField: UITextFieldValidated, error: UITextFieldValidated.ErrorType)
  func textFieldDidRemoveError(
    _ textField: UITextFieldValidated, error: UITextFieldValidated.ErrorType)
}
