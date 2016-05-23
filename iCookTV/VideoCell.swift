//
//  VideoCell.swift
//  TryTVOS
//
//  Created by Ben on 19/02/2016.
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
import Kingfisher

class VideoCell: UICollectionViewCell {

  private(set) lazy var imageView: UIImageView = {
    let _imageView = UIImageView()
    _imageView.image = UIImage.placeholderImage(withSize: self.bounds.size)
    _imageView.contentMode = .ScaleAspectFill
    return _imageView
  }()

  private(set) lazy var titleLabel: UILabel = {
    let _title = UILabel()
    _title.font = UIFont.tvFontForVideoCell()
    _title.textColor = UIColor.tvTextColor()
    _title.textAlignment = .Center
    return _title
  }()

  private(set) lazy var timeLabel: UILabel = {
    let _time = InsetLabel(contentEdgeInsets: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
    _time.font = UIFont.tvFontForVideoLength()
    _time.textColor = UIColor.whiteColor()
    _time.backgroundColor = UIColor.Palette.GreyishBrown
    _time.textAlignment = .Center
    _time.alpha = 0
    return _time
  }()

  private var timeLabelConstraints = (left: NSLayoutConstraint(), bottom: NSLayoutConstraint())

  /// Offsets due to the adjusted image bounds when focused.
  private let timeLabelOffsets = (
    left: (normal: CGFloat(0), focused: CGFloat(-20)),
    bottom: (normal: CGFloat(0), focused: CGFloat(-10))
  )

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpAppearance()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUpAppearance()
  }

  // MARK: - UICollectionViewCell

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.kf_cancelDownloadTask()
    imageView.image = UIImage.placeholderImage(withSize: bounds.size)
    titleLabel.text = nil
  }

  // MARK: - UIFocusEnvironment

  override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    let focused = (context.nextFocusedView == self)

    let color = focused ? UIColor.tvFocusedTextColor() : UIColor.tvTextColor()
    let transform = focused ?  CGAffineTransformMakeTranslation(0, 15) : CGAffineTransformIdentity
    let font = focused ? UIFont.tvFontForFocusedVideoCell() : UIFont.tvFontForVideoCell()
    let alpha: CGFloat = focused ? 1 : 0
    let offset = (
      left: focused ? self.timeLabelOffsets.left.focused : self.timeLabelOffsets.left.normal,
      bottom: focused ? self.timeLabelOffsets.bottom.focused : self.timeLabelOffsets.bottom.normal
    )

    coordinator.addCoordinatedAnimations({
      self.titleLabel.textColor = color
      self.titleLabel.transform = transform
      self.titleLabel.font = font
      self.timeLabel.alpha = alpha
      self.timeLabelConstraints.left.constant = offset.left
      self.timeLabelConstraints.bottom.constant = offset.bottom
      self.contentView.layoutIfNeeded()
    }, completion: nil)
  }

  // MARK: - Private Methods

  private func setUpAppearance() {
    clipsToBounds = false
    imageView.adjustsImageWhenAncestorFocused = true

    contentView.addSubview(imageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(timeLabel)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
    imageView.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor).active = true
    imageView.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor).active = true
    imageView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.topAnchor.constraintEqualToAnchor(imageView.bottomAnchor, constant: 20).active = true
    titleLabel.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor).active = true
    titleLabel.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor).active = true

    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    timeLabelConstraints.left = timeLabel.leadingAnchor.constraintEqualToAnchor(imageView.leadingAnchor, constant: timeLabelOffsets.left.normal)
    timeLabelConstraints.bottom = imageView.bottomAnchor.constraintEqualToAnchor(timeLabel.bottomAnchor, constant: timeLabelOffsets.bottom.normal)
    timeLabelConstraints.left.active = true
    timeLabelConstraints.bottom.active = true
  }

  // MARK: - Public Methods

  func configure(withVideo video: Video) {
    if let url = video.coverURL {
      imageView.kf_setImageWithURL(url, placeholderImage: UIImage.placeholderImage(withSize: bounds.size))
    }
    titleLabel.text = video.title
    timeLabel.text = video.timestamp
  }

}
