//
//  EmptyStateView.swift
//  iCookTV
//
//  Created by Ben on 28/04/2016.
//  Copyright © 2016 Polydice, Inc.
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

class EmptyStateView: UIView {

  private(set) lazy var imageView: UIImageView = {
    let _imageView = UIImageView()
    _imageView.image = UIImage(named: "icook-tv-cat")
    _imageView.contentMode = .ScaleAspectFill
    return _imageView
  }()

  private(set) lazy var textLabel: UILabel = {
    let _label = UILabel()
    _label.font = UIFont.tvFontForTagline()
    _label.textColor = UIColor.tvTaglineColor()
    _label.text = "No video found.".localizedString
    _label.textAlignment = .Center
    return _label
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUpSubviews()
  }

  // MARK: - Private Methods

  private func setUpSubviews() {
    addSubview(imageView)
    addSubview(textLabel)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    textLabel.translatesAutoresizingMaskIntoConstraints = false

    imageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true

    let views = [
      "image": imageView,
      "text": textLabel
    ]
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(>=0)-[image(280)]-(>=0)-|",
      options: [],
      metrics: nil,
      views: views
    ))
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[text]|",
      options: [],
      metrics: nil,
      views: views
    ))
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[image(350)]-50-[text]|",
      options: [],
      metrics: nil,
      views: views
    ))
  }

}
