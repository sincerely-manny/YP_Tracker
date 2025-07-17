import UIKit

final class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource,
  UIPageViewControllerDelegate
{

  private var pages: [UIViewController] = []

  private let pageControl: UIPageControl = {
    let control = UIPageControl()
    control.currentPageIndicatorTintColor = .ypBlack.appearance(.light)
    control.pageIndicatorTintColor = .ypGray.appearance(.light).withAlphaComponent(0.3)
    control.translatesAutoresizingMaskIntoConstraints = false
    return control
  }()

  private lazy var nextButton: UIButton = {
    let button = UIButton(type: .system)
    let title = NSLocalizedString("onboarding_button", comment: "Button title for onboarding")
    button.setTitle(title, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    button.backgroundColor = .ypBlack.appearance(.light)
    button.setTitleColor(.ypWhite.appearance(.light), for: .normal)
    button.layer.cornerRadius = 16
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupPages()
    setupPageViewController()
    setupView()
  }

  private func setupPages() {
    let texts = [
      NSLocalizedString("onboarding_title_1", comment: "First onboarding page text"),
      NSLocalizedString("onboarding_title_2", comment: "Second onboarding page text")
    ]

    let firstPage = OnboardingPageViewController(
      descriptionText: texts[0],
      backgroundImage: UIImage(resource: .onboardingBackground1))
    let secondPage = OnboardingPageViewController(
      descriptionText: texts[1],
      backgroundImage: UIImage(resource: .onboardingBackground2))

    pages = [firstPage, secondPage]
  }

  private func setupPageViewController() {
    dataSource = self
    delegate = self

    if let firstPage = pages.first {
      setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
    }
  }

  private func setupView() {
    view.backgroundColor = .white

    view.addSubview(pageControl)
    pageControl.numberOfPages = pages.count
    pageControl.currentPage = 0

    view.addSubview(nextButton)

    NSLayoutConstraint.activate([
      nextButton.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
      nextButton.heightAnchor.constraint(equalToConstant: 60),
      nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

      pageControl.bottomAnchor.constraint(
        equalTo: nextButton.topAnchor, constant: -24),
      pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }

  @objc private func nextButtonTapped() {
    guard let currentViewController = viewControllers?.first,
      let nextViewController = pageViewController(
        self, viewControllerAfter: currentViewController)
    else { return }

    setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
  }

  // MARK: - UIPageViewControllerDataSource

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
    pageControl.currentPage = index - 1
    return pages[index - 1]
  }

  func pageViewController(
    _ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
      goToIndex()
      return nil
    }
    pageControl.currentPage = index + 1
    return pages[index + 1]
  }

  private func goToIndex() {
    PersistentState.shared.isOnboardingCompleted = true
    let indexViewController = IndexTabbarController()
    indexViewController.modalPresentationStyle = .fullScreen

    if let windowScene = UIApplication.shared.connectedScenes
      .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
      let window = windowScene.windows.first
    {

      window.rootViewController = indexViewController
      UIView.transition(
        with: window,
        duration: 0.5,
        options: .transitionCrossDissolve,
        animations: nil,
        completion: nil
      )
    }
  }

}

final class OnboardingPageViewController: UIViewController {

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
    label.textColor = .ypBlack.appearance(.light)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()

  private let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()

  init(descriptionText: String, backgroundImage: UIImage? = nil) {
    super.init(nibName: nil, bundle: nil)
    descriptionLabel.text = descriptionText
    if let image = backgroundImage {
      backgroundImageView.image = image
    } else {
      backgroundImageView.backgroundColor = .lightGray
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(backgroundImageView)
    view.addSubview(descriptionLabel)
    setupConstraints()
  }

  private func setupConstraints() {
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

    let spacer = UILayoutGuide()
    view.addLayoutGuide(spacer)

    NSLayoutConstraint.activate([
      backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
      backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      spacer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      spacer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),

      descriptionLabel.bottomAnchor.constraint(equalTo: spacer.topAnchor),
      descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
  }

}
