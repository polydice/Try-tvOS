//
//  ICInsetLabel.swift
//  iCook
//
//  Created by Ben on 10/07/2015.
//  Copyright (c) 2015 Polydice, Inc.
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

class InsetLabel: UILabel {

  enum CornerRadius {
    case dynamic
    case constant(CGFloat)
  }

  var contentEdgeInsets = UIEdgeInsets.zero
  var cornerRadius = CornerRadius.constant(0)

  convenience init(contentEdgeInsets: UIEdgeInsets, cornerRadius: CornerRadius = .constant(0)) {
    self.init(frame: CGRect.zero)
    self.contentEdgeInsets = contentEdgeInsets
    self.cornerRadius = cornerRadius

    switch cornerRadius {
    case .constant(let radius) where radius > 0:
      layer.cornerRadius = radius
      fallthrough
    case .dynamic:
      layer.masksToBounds = true
      layer.shouldRasterize = true
      layer.rasterizationScale = UIScreen.main.scale
    default:
      break
    }
  }

  // MARK: - UIView

  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(
      width: contentEdgeInsets.left + size.width + contentEdgeInsets.right,
      height: contentEdgeInsets.top + size.height + contentEdgeInsets.bottom
    )
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    if case .dynamic = cornerRadius {
      layer.cornerRadius = frame.height / 2
    }
  }

}
