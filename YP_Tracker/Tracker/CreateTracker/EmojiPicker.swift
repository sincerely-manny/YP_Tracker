import UIKit

final class EmojiPicker: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource,
  UICollectionViewDelegateFlowLayout
{

  private let emojis: [String] = [
    "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
  ]

  var didSelectEmoji: ((String) -> Void)?
  var selectedEmoji: String?

  init() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 52, height: 52)
    layout.minimumInteritemSpacing = 5
    layout.minimumLineSpacing = 0
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
    layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

    super.init(frame: .zero, collectionViewLayout: layout)
    delegate = self
    dataSource = self
    register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
    register(
      UICollectionReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: "EmojiHeader")
    backgroundColor = .clear
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int
  {
    return emojis.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
    let label = UILabel()
    label.text = emojis[indexPath.item]
    label.font = UIFont.systemFont(ofSize: 32)
    label.textAlignment = .center
    label.frame = cell.contentView.bounds
    cell.contentView.addSubview(label)

    let selectedBackgroundView = UIView()
    selectedBackgroundView.backgroundColor = .ypLightGray
    selectedBackgroundView.layer.cornerRadius = 16
    selectedBackgroundView.layer.masksToBounds = true
    selectedBackgroundView.frame = cell.contentView.bounds
    cell.selectedBackgroundView = selectedBackgroundView

    if let selectedEmoji, emojis[indexPath.item] == selectedEmoji {
      selectItem(at: indexPath, animated: false, scrollPosition: [])
    }

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
        withReuseIdentifier: "EmojiHeader",
        for: indexPath)
      let label = UILabel()
      label.text = "Emoji"
      label.textColor = .ypBlack
      label.font = UIFont.boldSystemFont(ofSize: 19)
      label.translatesAutoresizingMaskIntoConstraints = false
      header.addSubview(label)

      NSLayoutConstraint.activate([
        label.topAnchor.constraint(equalTo: header.topAnchor),
        label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 6),
        label.trailingAnchor.constraint(equalTo: header.trailingAnchor),
        label.bottomAnchor.constraint(equalTo: header.bottomAnchor),
      ])

      return header
    }
    return UICollectionReusableView()
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedEmoji = emojis[indexPath.item]
    guard let selectedEmoji else { return }
    didSelectEmoji?(selectedEmoji)
  }

  func setSelected(_ emoji: String) {
    selectedEmoji = emoji
    if let index = emojis.firstIndex(of: emoji) {
      let indexPath = IndexPath(item: index, section: 0)
      selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
  }
}
