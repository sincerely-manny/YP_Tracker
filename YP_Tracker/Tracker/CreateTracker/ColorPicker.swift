import UIKit

final class ColorPicker: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource,
  UICollectionViewDelegateFlowLayout
{

  private let colors: [String] = [
    "#FD4C49", "#FF881E", "#007BFA", "#6E44FE", "#33CF69", "#E66DD4", "#F9D4D4", "#34A7FE",
    "#46E69D", "#35347C", "#FF674D", "#FF99CC", "#F6C48B", "#7994F5", "#832CF1", "#AD56DA",
    "#8D72E6", "#2FD058"
  ]

  var didSelectColor: ((String) -> Void)?

  init() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 48, height: 48)
    layout.minimumInteritemSpacing = 5
    layout.minimumLineSpacing = 0
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
    layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

    super.init(frame: .zero, collectionViewLayout: layout)
    delegate = self
    dataSource = self
    register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorsCell")
    register(
      UICollectionReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: "ColorsHeader")
    backgroundColor = .clear

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int
  {
    return colors.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCell", for: indexPath)

    let backgroundView = UIView()
    cell.backgroundView = backgroundView
    let notSelectedView = UIView()
    notSelectedView.backgroundColor = UIColor.init(hex: colors[indexPath.item])
    notSelectedView.layer.cornerRadius = 8
    notSelectedView.layer.masksToBounds = true
    notSelectedView.translatesAutoresizingMaskIntoConstraints = false
    backgroundView.addSubview(notSelectedView)
    NSLayoutConstraint.activate([
      notSelectedView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
      notSelectedView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
      notSelectedView.widthAnchor.constraint(equalToConstant: 40),
      notSelectedView.heightAnchor.constraint(equalToConstant: 40)
    ])

    let selectedBackgroundView = UIView()
    selectedBackgroundView.backgroundColor = UIColor.ypWhite
    cell.selectedBackgroundView = selectedBackgroundView
    let center = UIView()
    center.backgroundColor = UIColor.init(hex: colors[indexPath.item])
    center.layer.cornerRadius = 8
    center.layer.masksToBounds = true
    center.translatesAutoresizingMaskIntoConstraints = false
    selectedBackgroundView.addSubview(center)
    let outer = UIView()
    outer.layer.cornerRadius = 12
    outer.layer.masksToBounds = true
    outer.layer.borderWidth = 3
    outer.layer.borderColor =
      UIColor.init(hex: colors[indexPath.item])?.withAlphaComponent(0.3).cgColor
    selectedBackgroundView.addSubview(outer)
    NSLayoutConstraint.activate([
      center.centerXAnchor.constraint(equalTo: selectedBackgroundView.centerXAnchor),
      center.centerYAnchor.constraint(equalTo: selectedBackgroundView.centerYAnchor),
      center.widthAnchor.constraint(equalToConstant: 36),
      center.heightAnchor.constraint(equalToConstant: 36),

      outer.centerXAnchor.constraint(equalTo: selectedBackgroundView.centerXAnchor),
      outer.centerYAnchor.constraint(equalTo: selectedBackgroundView.centerYAnchor),
      outer.widthAnchor.constraint(equalToConstant: 48),
      outer.heightAnchor.constraint(equalToConstant: 48)
    ])

    outer.translatesAutoresizingMaskIntoConstraints = false

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: "ColorsHeader",
        for: indexPath)
      let label = UILabel()
      label.text = NSLocalizedString("color", comment: "Title for selecting a color")
      label.textColor = .ypBlack
      label.font = UIFont.boldSystemFont(ofSize: 19)
      label.translatesAutoresizingMaskIntoConstraints = false
      header.addSubview(label)

      NSLayoutConstraint.activate([
        label.topAnchor.constraint(equalTo: header.topAnchor),
        label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 6),
        label.trailingAnchor.constraint(equalTo: header.trailingAnchor),
        label.bottomAnchor.constraint(equalTo: header.bottomAnchor)
      ])

      return header
    }
    return UICollectionReusableView()
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedColor = colors[indexPath.item]
    didSelectColor?(selectedColor)
  }
}
