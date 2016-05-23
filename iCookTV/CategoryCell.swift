//
//  CategoryCell.swift
//  TryTVOS
//
//  Created by Ben on 23/03/2016.
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

class CategoryCell: UICollectionViewCell {

  var hasDisplayedCover: Bool {
    return tasks.isEmpty
  }

  // MARK: - Private Properties

  private(set) lazy var imageView: UIImageView = {
    let _imageView = UIImageView()
    _imageView.image = UIImage.placeholderImage(withSize: self.bounds.size)
    _imageView.contentMode = .ScaleAspectFill
    return _imageView
  }()

  private(set) lazy var textLabel: UILabel = {
    let _label = UILabel()
    _label.font = UIFont.tvFontForCategoryCell()
    _label.textColor = UIColor.tvTextColor()
    _label.textAlignment = .Center
    return _label
  }()

  private let coverBuilder = CoverBuilder()

  private var tasks = [Grid: RetrieveImageDownloadTask]()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUpSubviews()
  }

  // MARK: - UICollectionViewCell

  override func prepareForReuse() {
    super.prepareForReuse()
    for (index, task) in tasks {
      task.cancel()
      tasks[index] = nil
    }
    coverBuilder.resetCover()
    imageView.image = UIImage.placeholderImage(withSize: bounds.size)
    textLabel.text = nil
  }

  // MARK: - UIFocusEnvironment

  override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    let focused = (context.nextFocusedView == self)

    let color = focused ? UIColor.tvFocusedTextColor() : UIColor.tvTextColor()
    let transform = focused ? CGAffineTransformMakeTranslation(0, 25) : CGAffineTransformIdentity
    let font = focused ? UIFont.tvFontForFocusedCategoryCell() : UIFont.tvFontForCategoryCell()

    coordinator.addCoordinatedAnimations({
      self.textLabel.textColor = color
      self.textLabel.transform = transform
      self.textLabel.font = font
    }, completion: nil)
  }

  // MARK: - Private Methods

  private func setUpSubviews() {
    clipsToBounds = false
    imageView.adjustsImageWhenAncestorFocused = true

    contentView.addSubview(imageView)
    contentView.addSubview(textLabel)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
    imageView.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor).active = true
    imageView.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor).active = true
    imageView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true

    textLabel.translatesAutoresizingMaskIntoConstraints = false
    textLabel.topAnchor.constraintEqualToAnchor(imageView.bottomAnchor, constant: 22).active = true
    textLabel.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor).active = true
    textLabel.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor).active = true
  }

  func setUpCover(urls: [Grid: NSURL], forCategory category: Category) {
    // Cancel previous tasks
    for (corner, task) in tasks {
      task.cancel()
      tasks[corner] = nil
    }

    for (corner, url) in urls {
      let downloading = ImageDownloader.defaultDownloader.downloadImageWithURL(url, progressBlock: nil) {
        [weak self] image, error, imageURL, originalData in

        self?.tasks[corner] = nil
        guard let image = image where imageURL == url else {
          return
        }

        self?.coverBuilder.addImage(image, atCorner: corner, categoryID: category.id) { newCover in
          if let current = self {
            UIView.transitionWithView(
              current.imageView,
              duration: 0.3,
              options: [.BeginFromCurrentState, .TransitionCrossDissolve, .CurveEaseIn],
              animations: {
                self?.imageView.image = newCover
              }, completion: nil
            )
          }
        }
      }
      if let task = downloading {
        tasks[corner] = task
      }
    }
  }

  // MARK: - Public Methods

  func configure(withCategory category: Category) {
    textLabel.text = category.name

    if let cached = coverBuilder.coverForCategory(withID: category.id) {
      imageView.image = cached
      return
    }

    var urls = [Grid: NSURL]()
    for (index, value) in category.coverURLs.enumerate() {
      guard let corner = Grid(rawValue: index), let url = NSURL(string: value) else { continue }
      urls[corner] = url
    }

    setUpCover(urls, forCategory: category)
  }

}
