import UIKit

final class CategoryCreationViewController: UIViewController, UITextFieldDelegate {
  private let dataProvider = DataProvider.shared
  private var categoryNameTextField: UITextField?

  var didCreateCategory: ((TrackerCategory) -> Void)?

  private lazy var createButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Готово", for: .normal)
    button.addTarget(self, action: #selector(createCategoryTapped), for: .touchUpInside)
    button.backgroundColor = .ypGray
    button.setTitleColor(.ypWhite, for: .normal)
    button.layer.cornerRadius = 16
    button.isEnabled = false
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    button.layer.masksToBounds = true

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  private func setupView() {
    title = "Новая категория"
    view.backgroundColor = .ypWhite

    let textField = UITextField()
    textField.placeholder = "Введите название категории"
    textField.backgroundColor = .ypBackground
    textField.layer.cornerRadius = 16
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    textField.textColor = .ypBlack
    textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
    textField.leftView = paddingView
    textField.leftViewMode = .always
    textField.rightView = paddingView
    textField.rightViewMode = .always

    textField.returnKeyType = .done
    textField.delegate = self

    view.addSubview(textField)
    categoryNameTextField = textField

    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
      textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      textField.heightAnchor.constraint(equalToConstant: 75),
    ])

    view.addSubview(createButton)

    NSLayoutConstraint.activate([
      createButton.heightAnchor.constraint(equalToConstant: 60),
      createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      createButton.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
    ])
  }

  @objc private func createCategoryTapped() {
    guard let name = categoryNameTextField?.text, !name.isEmpty else { return }

    do {
      let category = try dataProvider.createCategory(name: name)
      didCreateCategory?(category)

      navigationController?.popViewController(animated: true)
    } catch {
      assertionFailure("Failed to create category: \(error)")
      return
    }

  }

  @objc private func textFieldChanged(_ textField: UITextField) {
    guard let text = textField.text, !text.isEmpty else {
      createButton.isEnabled = false
      createButton.backgroundColor = .ypGray
      return
    }

    createButton.isEnabled = true
    createButton.backgroundColor = .ypBlack
  }
}

// MARK: - UITextFieldDelegate
extension CategoryCreationViewController {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
