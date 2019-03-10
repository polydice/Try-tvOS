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
    let imageView = UIImageView()
    imageView.image = UIImage.placeholderImage(with: self.bounds.size)
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private(set) lazy var titleLabel: UILabel = {
    let title = UILabel()
    title.font = UIFont.tvFontForVideoCell()
    title.textColor = UIColor.tvTextColor()
    title.textAlignment = .center
    return title
  }()

  private(set) lazy var timeLabel: UILabel = {
    let time = InsetLabel(contentEdgeInsets: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
    time.font = UIFont.tvFontForVideoLength()
    time.textColor = UIColor.white
    time.backgroundColor = UIColor.Palette.GreyishBrown
    time.textAlignment = .center
    time.alpha = 0
    return time
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
    imageView.kf.cancelDownloadTask()
    imageView.image = UIImage.placeholderImage(with: bounds.size)
    titleLabel.text = nil
  }

  // MARK: - UIFocusEnvironment

  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    let focused = (context.nextFocusedView == self)

    let color = focused ? UIColor.tvFocusedTextColor() : UIColor.tvTextColor()
    let transform = focused ?  CGAffineTransform(translationX: 0, y: 15) : CGAffineTransform.identity
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
    imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
    imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
    titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
    titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    timeLabelConstraints.left = timeLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: timeLabelOffsets.left.normal)
    timeLabelConstraints.bottom = imageView.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: timeLabelOffsets.bottom.normal)
    timeLabelConstraints.left.isActive = true
    timeLabelConstraints.bottom.isActive = true
  }

  // MARK: - Public Methods

  func configure(with video: Video) {
    if let url = video.coverURL {
      imageView.kf.setImage(with: url, placeholder: UIImage.placeholderImage(with: bounds.size))
    }
    titleLabel.text = video.title
    timeLabel.text = video.timestamp
  }

}
