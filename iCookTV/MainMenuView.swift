//
//  MainMenuView.swift
//  TryTVOS
//
//  Created by Ben on 09/04/2016.
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

class MainMenuView: UIView {

  private let frontBanner = UIImageView(image: UIImage(named: "icook-tv-banner-food-front"))
  private let backBanner = UIImageView(image: UIImage(named: "icook-tv-banner-food-back"))
  private let imageView = UIImageView(image: UIImage(named: "icook-tv-logo"))

  private(set) lazy var titleLabel: UILabel = {
    let _title = UILabel()
    _title.font = UIFont.tvFontForLogo()
    _title.textColor = UIColor.tvHeaderTitleColor()
    _title.text = "iCook TV".localizedString
    return _title
  }()

  private(set) lazy var button: UIButton = {
    let _button = MenuButton(type: .System)
    _button.titleLabel?.font = UIFont.tvFontForHeaderTitle()
    return _button
  }()

  private let focusGuide = UIFocusGuide()
  private var frontBannerConstraint: NSLayoutConstraint?
  private var backBannerConstraint: NSLayoutConstraint?

  private let bannerOffset = (
    front: (normal: CGFloat(0), focused: CGFloat(-20)),
    back: (normal: CGFloat(-20), focused: CGFloat(0))
  )

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUpSubviews()
  }

  // MARK: - UIFocusEnvironment

  override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    let focused = (context.nextFocusedView == button)

    coordinator.addCoordinatedAnimations({
      self.frontBannerConstraint?.constant = focused ? self.bannerOffset.front.focused : self.bannerOffset.front.normal
      self.backBannerConstraint?.constant = focused ? self.bannerOffset.back.focused : self.bannerOffset.back.normal
      self.layoutIfNeeded()
    }, completion: nil)
  }

  // MARK: - Private Methods

  private func setUpSubviews() {
    addSubview(backBanner)
    addSubview(frontBanner)
    addSubview(imageView)
    addSubview(titleLabel)
    addSubview(button)
    addLayoutGuide(focusGuide)

    frontBanner.translatesAutoresizingMaskIntoConstraints = false
    backBanner.translatesAutoresizingMaskIntoConstraints = false
    imageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    button.translatesAutoresizingMaskIntoConstraints = false

    frontBanner.topAnchor.constraintEqualToAnchor(topAnchor).active = true
    frontBannerConstraint = frontBanner.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: bannerOffset.front.normal)
    frontBannerConstraint?.active = true

    backBanner.topAnchor.constraintEqualToAnchor(topAnchor).active = true
    backBannerConstraint = backBanner.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: bannerOffset.back.normal)
    backBannerConstraint?.active = true

    focusGuide.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
    focusGuide.trailingAnchor.constraintEqualToAnchor(button.leadingAnchor).active = true
    focusGuide.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
    focusGuide.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true

    imageView.contentMode = .ScaleAspectFill
    imageView.widthAnchor.constraintEqualToConstant(120).active = true
    imageView.heightAnchor.constraintEqualToConstant(88).active = true
    imageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 222).active = true
    imageView.topAnchor.constraintEqualToAnchor(topAnchor, constant: 136).active = true

    titleLabel.leadingAnchor.constraintEqualToAnchor(imageView.trailingAnchor, constant: 20).active = true
    titleLabel.topAnchor.constraintEqualToAnchor(topAnchor, constant: 150).active = true

    button.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -148).active = true
    button.centerYAnchor.constraintEqualToAnchor(titleLabel.centerYAnchor).active = true
  }

}
