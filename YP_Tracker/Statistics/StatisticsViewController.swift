import UIKit

final class StatisticsViewController: UIViewController {

  private lazy var best = StatisticsItem(title: "Лучший период")
  private lazy var ideal = StatisticsItem(title: "Идеальные дни")
  private lazy var done = StatisticsItem(title: "Трекеров завершено")
  private lazy var average = StatisticsItem(title: "Среднее значение")

  private var trackerStore: TrackerStore?
  private var trackerRecordStore: TrackerRecordStore?
  private var statisticsService: StatisticsService?
  private var trackerStatistics: TrackerStatistics? {
    didSet {
      updateUI()
    }
  }

  private lazy var emptyView = StatisticsEmpty()

  init() {
    super.init(nibName: nil, bundle: nil)
    trackerStore = DataProvider.getTrackerStore(delegate: self)
    trackerRecordStore = DataProvider.getTrackerRecordStore(delegate: self)
    guard let trackerStore, let trackerRecordStore else { return }
    statisticsService = StatisticsService(
      trackerStore: trackerStore,
      trackerRecordStore: trackerRecordStore
    )
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  private func setupView() {
    title = NSLocalizedString("statistics", comment: "Statistics title")

    for (index, item) in [best, ideal, done, average].enumerated() {
      view.addSubview(item)
      item.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        item.topAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(index) * 102),
        item.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        item.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        item.heightAnchor.constraint(equalToConstant: 90)
      ])
    }

    view.addSubview(emptyView)
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    emptyView.isHidden = true

    trackerStatistics = statisticsService?.calculateStatistics()
  }

  private func updateUI() {
    best.count = trackerStatistics?.bestPeriod ?? 0
    ideal.count = trackerStatistics?.perfectDays ?? 0
    done.count = trackerStatistics?.trackersCompleted ?? 0
    average.count = trackerStatistics?.averageValue ?? 0

    if best.count + ideal.count + done.count + average.count == 0 {
      emptyView.isHidden = false
      best.isHidden = true
      ideal.isHidden = true
      done.isHidden = true
      average.isHidden = true
    } else {
      emptyView.isHidden = true
      best.isHidden = false
      ideal.isHidden = false
      done.isHidden = false
      average.isHidden = false
    }

  }
}

extension StatisticsViewController: TrackerRecordStoreDelegate {
  func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
    trackerStatistics = statisticsService?.calculateStatistics()
  }
}

extension StatisticsViewController: TrackerStoreDelegate {
  func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
    trackerStatistics = statisticsService?.calculateStatistics()
  }

}

final class StatisticsEmpty: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView() {
    let imageView = UIImageView(image: UIImage(resource: .cryFace))
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.heightAnchor.constraint(equalToConstant: 80),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])

    let label = UILabel()
    label.text = "Анализировать пока нечего"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])
  }
}
