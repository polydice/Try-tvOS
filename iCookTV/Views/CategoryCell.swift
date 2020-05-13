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
    _imageView.image = UIImage.placeholderImage(with: self.bounds.size)
    _imageView.contentMode = .scaleAspectFill
    return _imageView
  }()

  private(set) lazy var textLabel: UILabel = {
    let _label = UILabel()
    _label.font = UIFont.tvFontForCategoryCell()
    _label.textColor = UIColor.tvTextColor()
    _label.textAlignment = .center
    return _label
  }()

  private let coverBuilder = CoverBuilder()

  private var tasks = [Grid: DownloadTask]()

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
    imageView.image = UIImage.placeholderImage(with: bounds.size)
    textLabel.text = nil
  }

  // MARK: - UIFocusEnvironment

  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    let focused = (context.nextFocusedView == self)

    let color = focused ? UIColor.tvFocusedTextColor() : UIColor.tvTextColor()
    let transform = focused ? CGAffineTransform(translationX: 0, y: 25) : CGAffineTransform.identity
    let font = focused ? UIFont.tvFontForFocusedCategoryCell() : UIFont.tvFontForCategoryCell()

    coordinator.addCoordinatedAnimations({
      self.textLabel.textColor = color
      self.textLabel.transform = transform
      self.textLabel.font = font
    }, completion: nil)
  }

  // MARK: - Private Methods

  fileprivate func setUpSubviews() {
    clipsToBounds = false
    imageView.adjustsImageWhenAncestorFocused = true

    contentView.addSubview(imageView)
    contentView.addSubview(textLabel)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
    imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    textLabel.translatesAutoresizingMaskIntoConstraints = false
    textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 22).isActive = true
    textLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
    textLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
  }

  func setUpCover(_ urls: [Grid: URL], forCategory category: Category) {
    // Cancel previous tasks
    for (grid, task) in tasks {
      task.cancel()
      tasks[grid] = nil
    }

    for (grid, url) in urls {
      let downloading = ImageDownloader.default.downloadImage(with: url, options: []) { [weak self] in
        self?.tasks[grid] = nil
        guard let result = try? $0.get(), result.url == url else {
          return
        }
        let image = result.image

        self?.coverBuilder.add(image: image, to: grid, categoryID: category.id) { newCover in
          if let current = self {
            UIView.transition(
              with: current.imageView,
              duration: 0.3,
              options: [.beginFromCurrentState, .transitionCrossDissolve, .curveEaseIn],
              animations: {
                self?.imageView.image = newCover
              }, completion: nil
            )
          }
        }
      }
      if let task = downloading {
        tasks[grid] = task
      }
    }
  }

  // MARK: - Public Methods

  func configure(with category: Category) {
    textLabel.text = category.name

    if let cached = coverBuilder.coverForCategory(withID: category.id) {
      imageView.image = cached
      return
    }

    var urls = [Grid: URL]()
    for (index, value) in category.coverURLs.enumerated() {
      guard let grid = Grid(rawValue: index), let url = URL(string: value) else { continue }
      urls[grid] = url
    }

    setUpCover(urls, forCategory: category)
  }

}
