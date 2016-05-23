//
//  CategoryHeaderView.swift
//  TryTVOS
//
//  Created by Ben on 21/03/2016.
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

/// A customized view with a layout of `H:|-[icon]-[title]-(>=0)-[accessory]-|`.
class CategoryHeaderView: UICollectionReusableView {

  static let requiredHeight = CGFloat(140)

  private let imageView = UIImageView(image: UIImage(named: "icook-tv-logo"))

  private(set) lazy var titleLabel: UILabel = {
    let _title = UILabel()
    _title.font = UIFont.tvFontForHeaderTitle()
    _title.textColor = UIColor.tvHeaderTitleColor()
    _title.text = "iCook TV".localizedString
    return _title
  }()

  private(set) lazy var accessoryLabel: UILabel = {
    let _accessory = UILabel()
    _accessory.font = UIFont.tvFontForHeaderTitle()
    _accessory.textColor = UIColor.tvHeaderTitleColor()
    return _accessory
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
    addSubview(titleLabel)
    addSubview(accessoryLabel)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    accessoryLabel.translatesAutoresizingMaskIntoConstraints = false

    imageView.contentMode = .ScaleAspectFill
    imageView.widthAnchor.constraintEqualToConstant(87).active = true
    imageView.heightAnchor.constraintEqualToConstant(64).active = true
    imageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: Metrics.EdgePadding.left).active = true
    imageView.centerYAnchor.constraintEqualToAnchor(titleLabel.centerYAnchor).active = true

    titleLabel.leadingAnchor.constraintEqualToAnchor(imageView.trailingAnchor, constant: 20).active = true
    titleLabel.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -10).active = true

    accessoryLabel.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -Metrics.EdgePadding.right).active = true
    accessoryLabel.centerYAnchor.constraintEqualToAnchor(titleLabel.centerYAnchor).active = true
  }

}
