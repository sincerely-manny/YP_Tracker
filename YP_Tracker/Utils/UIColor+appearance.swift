import UIKit

extension UIColor {
  func appearance(_ interfaceStyle: UIUserInterfaceStyle) -> UIColor {
    self.resolvedColor(with: UITraitCollection(userInterfaceStyle: interfaceStyle))
  }
}
