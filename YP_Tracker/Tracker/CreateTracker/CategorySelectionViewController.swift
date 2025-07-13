import UIKit

final class CategorySelectionViewController: UIViewController, UITableViewDelegate,
  UITableViewDataSource
{
  private var tableView: UITableView?
  var categories: [TrackerCategory] = DataProvider.shared.trackerCategoryStore.fetchCategories() {
    didSet {
      if !categories.isEmpty {
        tableView?.backgroundView?.isHidden = true
      } else {
        tableView?.backgroundView?.isHidden = false
      }
      tableView?.reloadData()
    }
  }
  var selectedCategory: TrackerCategory?

  var didSelectCategory: ((TrackerCategory) -> Void)?

  private lazy var addCategoryButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Добавить категорию", for: .normal)
    button.addTarget(self, action: #selector(addCategoryTapped), for: .touchUpInside)
    button.backgroundColor = .ypBlack
    button.setTitleColor(.ypWhite, for: .normal)
    button.layer.cornerRadius = 16
    button.translatesAutoresizingMaskIntoConstraints = false
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)

    return button
  }()

  init(selectedCategory: TrackerCategory? = nil) {
    self.selectedCategory = selectedCategory
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
    title = "Категория"
    view.backgroundColor = .ypWhite

    view.addSubview(addCategoryButton)
    addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      addCategoryButton.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
      addCategoryButton.leadingAnchor.constraint(
        equalTo: view.leadingAnchor, constant: 20),
      addCategoryButton.trailingAnchor.constraint(
        equalTo: view.trailingAnchor, constant: -20),
    ])

    setupTableView()
    guard let tableView else { return }
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(
        equalTo: addCategoryButton.topAnchor, constant: -16),
    ])
  }

  private func setupTableView() {
    tableView = UITableView(frame: view.bounds, style: .insetGrouped)
    guard let tableView = tableView else { return }

    tableView.delegate = self
    tableView.dataSource = self

    let emptyPlaceholder = EmptyListPlaceholder(
      text: "Привычки и события можно\nобъединить по смыслу")
    tableView.backgroundColor = .clear
    tableView.backgroundView = emptyPlaceholder
    tableView.backgroundView?.frame = tableView.bounds
    tableView.backgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tableView.backgroundView?.isHidden = !categories.isEmpty
    tableView.rowHeight = 75
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }

  func tableView(
    _ tableView: UITableView, cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")
    cell.selectionStyle = .none
    cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    cell.textLabel?.textColor = .ypBlack
    cell.backgroundColor = .ypBackground
    cell.layer.cornerRadius = 16
    let category = categories[indexPath.row]
    cell.textLabel?.text = category.name
    cell.accessoryType = (category.id == selectedCategory?.id) ? .checkmark : .none
    return cell
  }

  func tableView(
    _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selectedCategory = categories[indexPath.row]
    self.selectedCategory = selectedCategory
    didSelectCategory?(selectedCategory)
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }

  @objc private func addCategoryTapped() {
    let categoryCreationVC = CategoryCreationViewController()
    categoryCreationVC.didCreateCategory = { [weak self] newCategory in
      guard let self else { return }
      self.categories.append(newCategory)
      self.selectedCategory = newCategory
      self.didSelectCategory?(newCategory)
      self.tableView?.reloadData()
    }
    navigationController?.pushViewController(categoryCreationVC, animated: true)
  }

}
