import Combine
import UIKit

final class CategorySelectionViewModel {
  typealias Binding<T> = (T) -> Void

  @Published private(set) var categories: [TrackerCategory] = []
  @Published private(set) var selectedCategory: TrackerCategory?

  var didSelectCategory: Binding<TrackerCategory>?

  private let model: TrackerCategoryStore

  init(
    selectedCategory: TrackerCategory? = nil,
    model: TrackerCategoryStore = DataProvider.shared.trackerCategoryStore
  ) {
    self.selectedCategory = selectedCategory
    self.model = model
    fetchCategories()
  }

  func fetchCategories() {
    categories = model.fetchCategories()
  }

  func selectCategory(at indexPath: IndexPath) {
    guard indexPath.row < categories.count else { return }
    let category = categories[indexPath.row]
    selectedCategory = category
    didSelectCategory?(category)
  }

  func categoryCreated(_ newCategory: TrackerCategory) {
    fetchCategories()
    selectedCategory = categories.first { $0.id == newCategory.id }
    if let selected = selectedCategory {
      didSelectCategory?(selected)
    }
  }

  func addCategoryTapped(navigationController: UINavigationController?) {
    let categoryCreationVC = CategoryCreationViewController()
    categoryCreationVC.didCreateCategory = { [weak self] newCategory in
      self?.categoryCreated(newCategory)
    }
    navigationController?.pushViewController(categoryCreationVC, animated: true)
  }

}
