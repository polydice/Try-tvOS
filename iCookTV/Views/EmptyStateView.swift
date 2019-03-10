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
    let imageView = UIImageView()
    imageView.image = R.image.icookTvCat()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private(set) lazy var textLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.tvFontForTagline()
    label.textColor = UIColor.tvTaglineColor()
    label.text = R.string.localizable.noVideoFound()
    label.textAlignment = .center
    return label
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

    imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

    let views: [String: Any] = [
      "image": imageView,
      "text": textLabel
    ]
    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-(>=0)-[image(280)]-(>=0)-|",
      options: [],
      metrics: nil,
      views: views
    ))
    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[text]|",
      options: [],
      metrics: nil,
      views: views
    ))
    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[image(350)]-50-[text]|",
      options: [],
      metrics: nil,
      views: views
    ))
  }

}
