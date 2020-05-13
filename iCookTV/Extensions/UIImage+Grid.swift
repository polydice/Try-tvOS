//
//  UIImage+Grid.swift
//  TryTVOS
//
//  Created by Ben on 28/03/2016.
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

extension UIImage {

  func image(byReplacingImage image: UIImage, in grid: Grid) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, true, 0)

    let canvas = CGRect(origin: CGPoint.zero, size: size)
    self.draw(in: canvas)

    let rect = canvas.rect(with: image.size, in: grid)
    image.draw(in: rect)

    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage
  }

  class func placeholderImage(with size: CGSize) -> UIImage? {
    let layer = CAGradientLayer()
    layer.frame = CGRect(origin: CGPoint.zero, size: size)
    layer.colors = [UIColor.white.cgColor, UIColor.Palette.LightGray.cgColor]
    layer.startPoint = CGPoint(x: 0, y: 0)
    layer.endPoint = CGPoint(x: 1, y: 1)

    UIGraphicsBeginImageContext(size)

    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }

    layer.render(in: context)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
  }

  class func resizableImage(filledWith color: UIColor) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0)

    color.setFill()
    UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image?.resizableImage(withCapInsets: UIEdgeInsets.zero)
  }

}
