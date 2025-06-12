import UIKit

final class TrackerIndexViewController: UIViewController {
  private lazy var leftNavigationItemButton = {
    let button = UIBarButtonItem(
      image: UIImage(
        systemName: "plus",
        withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)),
      style: .plain, target: self, action: nil)

    return button
  }()

  private lazy var rightNavigationItemButton = {
    let button = UIButton(type: .system)
    button.setTitle("14.12.22", for: .normal)
    button.layer.cornerRadius = 8
    button.layer.backgroundColor = UIColor(hex: "#F0F0F0")?.cgColor
    button.setTitleColor(
      .ypBlack.appearance(.light), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    button.contentEdgeInsets = UIEdgeInsets(
      top: 6, left: 5.5, bottom: 6, right: 5.5)
    return UIBarButtonItem(customView: button)
  }()

  private lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "Поиск"
    searchBar.searchTextField.layer.cornerRadius = 8
    searchBar.searchTextField.layer.masksToBounds = true
    searchBar.backgroundImage = UIImage()
    return searchBar
  }()

  private lazy var emptyListPlaceholder: UIView = {
    let view = UIView()
    let container = UIView()
    view.addSubview(container)
    container.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      container.leadingAnchor.constraint(
        equalTo: view.leadingAnchor),
      container.trailingAnchor.constraint(
        equalTo: view.trailingAnchor),
    ])

    let imageView = UIImageView(image: UIImage(named: "empty_list"))
    container.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      imageView.topAnchor.constraint(equalTo: container.topAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 80),
      imageView.widthAnchor.constraint(equalToConstant: 80),
    ])

    let label = UILabel()
    label.text = "Что будем отслеживать?"
    label.textColor = UIColor.ypBlack.appearance(.light)
    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    label.textAlignment = .center
    container.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
      label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
      label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
    ])

    return view
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

    view.addSubview(emptyListPlaceholder)
    emptyListPlaceholder.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      emptyListPlaceholder.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      emptyListPlaceholder.leadingAnchor.constraint(
        equalTo: view.layoutMarginsGuide.leadingAnchor),
      emptyListPlaceholder.trailingAnchor.constraint(
        equalTo: view.layoutMarginsGuide.trailingAnchor),
      emptyListPlaceholder.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])

  }
}
