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

  private let frontBanner = UIImageView(image: R.image.icookTvBannerFoodFront())
  private let backBanner = UIImageView(image: R.image.icookTvBannerFoodBack())
  private let imageView = UIImageView(image: R.image.icookTvLogo())

  private(set) lazy var titleLabel: UILabel = {
    let title = UILabel()
    title.font = UIFont.tvFontForLogo()
    title.textColor = UIColor.tvHeaderTitleColor()
    title.text = R.string.localizable.icookTv()
    return title
  }()

  private(set) lazy var button: UIButton = {
    let button = MenuButton(type: .system)
    button.titleLabel?.font = UIFont.tvFontForHeaderTitle()
    return button
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

  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
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

    frontBanner.topAnchor.constraint(equalTo: topAnchor).isActive = true
    frontBannerConstraint = frontBanner.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bannerOffset.front.normal)
    frontBannerConstraint?.isActive = true

    backBanner.topAnchor.constraint(equalTo: topAnchor).isActive = true
    backBannerConstraint = backBanner.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bannerOffset.back.normal)
    backBannerConstraint?.isActive = true

    focusGuide.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    focusGuide.trailingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
    focusGuide.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    focusGuide.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    if #available(tvOS 10.0, *) {
      focusGuide.preferredFocusEnvironments = [button]
    } else {
      focusGuide.preferredFocusedView = button
    }

    imageView.contentMode = .scaleAspectFill
    imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 88).isActive = true
    imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 222).isActive = true
    imageView.topAnchor.constraint(equalTo: topAnchor, constant: 136).isActive = true

    titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20).isActive = true
    titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 150).isActive = true

    button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -148).isActive = true
    button.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
  }

}
