//
//  UIFont+TV.swift
//  TryTVOS
//
//  Created by Ben on 05/04/2016.
//  Copyright © 2016 bcylin.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

extension UIFont {

  private enum FontFamily {
    static let PingFangTCRegular = "PingFangTC-Regular"
    static let PingFangTCMedium = "PingFangTC-Medium"
  }

  // MARK: - Private Methods

  private class func tvFontOfSize(fontSize: CGFloat) -> UIFont {
    return UIFont(name: FontFamily.PingFangTCRegular, size: fontSize) ?? UIFont.systemFontOfSize(fontSize)
  }

  private class func tvBoldFontOfSize(fontSize: CGFloat) -> UIFont {
    return UIFont(name: FontFamily.PingFangTCMedium, size: fontSize) ?? UIFont.boldSystemFontOfSize(fontSize)
  }

  // MARK: - Public Methods

  class func tvFontForTagline() -> UIFont {
    return UIFont.tvFontOfSize(44)
  }

  class func tvFontForCategoryCell() -> UIFont {
    return UIFont.tvFontOfSize(35)
  }

  class func tvFontForFocusedCategoryCell() -> UIFont {
    return UIFont.tvFontOfSize(40)
  }

  class func tvFontForVideoCell() -> UIFont {
    return UIFont.tvFontOfSize(29)
  }

  class func tvFontForFocusedVideoCell() -> UIFont {
    return UIFont.tvBoldFontOfSize(29)
  }

  class func tvFontForVideoLength() -> UIFont {
    return UIFont.systemFontOfSize(20)
  }

  class func tvFontForLogo() -> UIFont {
    return UIFont.tvFontOfSize(65)
  }

  class func tvFontForMenuButton() -> UIFont {
    return UIFont.tvFontOfSize(30)
  }

  class func tvFontForHeaderTitle() -> UIFont {
    return UIFont.tvFontOfSize(35)
  }

}
