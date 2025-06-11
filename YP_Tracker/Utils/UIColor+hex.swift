import UIKit

extension UIColor {
  public convenience init?(hex: String) {
    let r: CGFloat
    let g: CGFloat
    let b: CGFloat
    let a: CGFloat

    if hex.hasPrefix("#") {
      let start = hex.index(hex.startIndex, offsetBy: 1)
      var hexColor = String(hex[start...])

      if hexColor.count == 6 {
        hexColor += "FF"
      }

      if hexColor.count == 8 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
          r = CGFloat((hexNumber & 0xff00_0000) >> 24) / 255
          g = CGFloat((hexNumber & 0x00ff_0000) >> 16) / 255
          b = CGFloat((hexNumber & 0x0000_ff00) >> 8) / 255
          a = CGFloat(hexNumber & 0x0000_00ff) / 255

          self.init(red: r, green: g, blue: b, alpha: a)
          return
        }
      }
    }

    return nil
  }
}
