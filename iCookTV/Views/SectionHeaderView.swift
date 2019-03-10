//
//  SectionHeaderView.swift
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
class SectionHeaderView: UICollectionReusableView {

  static let requiredHeight = CGFloat(140)

  private let imageView = UIImageView(image: R.image.icookTvLogo())

  private(set) lazy var titleLabel: UILabel = {
    let title = UILabel()
    title.font = UIFont.tvFontForHeaderTitle()
    title.textColor = UIColor.tvHeaderTitleColor()
    title.text = R.string.localizable.icookTv()
    return title
  }()

  private(set) lazy var accessoryLabel: UILabel = {
    let accessory = UILabel()
    accessory.font = UIFont.tvFontForHeaderTitle()
    accessory.textColor = UIColor.tvHeaderTitleColor()
    return accessory
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

    imageView.contentMode = .scaleAspectFill
    imageView.widthAnchor.constraint(equalToConstant: 87).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
    imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.EdgePadding.left).isActive = true
    imageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true

    titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true

    accessoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.EdgePadding.right).isActive = true
    accessoryLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
  }

}
