import UIKit

final class EmptyListPlaceholder: UIView {
  var text = ""

  init(text: String) {
    super.init(frame: .zero)
    self.text = text
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    let container = UIView()
    addSubview(container)
    container.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      container.centerYAnchor.constraint(equalTo: centerYAnchor),
      container.centerXAnchor.constraint(equalTo: centerXAnchor),
      container.leadingAnchor.constraint(equalTo: leadingAnchor),
      container.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])

    let imageView = UIImageView(image: UIImage(named: "empty_list"))
    imageView.contentMode = .scaleAspectFit
    container.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      imageView.topAnchor.constraint(equalTo: container.topAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 80),
      imageView.widthAnchor.constraint(equalToConstant: 80),
    ])

    let label = UILabel()
    label.text = text
    label.textColor = UIColor.ypBlack
    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    label.textAlignment = .center
    label.numberOfLines = 2
    container.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
      label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
      label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
    ])
  }
}
