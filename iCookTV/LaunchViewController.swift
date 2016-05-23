//
//  LaunchViewController.swift
//  TryTVOS
//
//  Created by Ben on 10/04/2016.
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
import Alamofire
import Freddy

class LaunchViewController: UIViewController {

  private lazy var loadingImageView: UIImageView = {
    let _imageView = UIImageView()
    _imageView.image = UIImage(named: "icook-tv-cat")
    _imageView.contentMode = .ScaleAspectFill
    return _imageView
  }()

  private lazy var activityIndicator: UIActivityIndicatorView = {
    let _indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    _indicator.color = UIColor.Palette.GreyishBrown
    _indicator.hidesWhenStopped = true
    return _indicator
  }()

  private lazy var upperTaglineLabel: UILabel = {
    let _upper = UILabel.taglineLabel()
    _upper.text = "Upper tagline".localizedString
    return _upper
  }()

  private lazy var lowerTaglineLabel: UILabel = {
    let _lower = UILabel.taglineLabel()
    _lower.text = "Lower tagline".localizedString
    return _lower
  }()

  private var upperTaglineConstraint: NSLayoutConstraint?
  private var lowerTaglineConstraint: NSLayoutConstraint?

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    view.backgroundColor = UIColor.tvBackgroundColor()
    view.addSubview(loadingImageView)
    view.addSubview(activityIndicator)
    view.addSubview(upperTaglineLabel)
    view.addSubview(lowerTaglineLabel)

    loadingImageView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    upperTaglineLabel.translatesAutoresizingMaskIntoConstraints = false
    lowerTaglineLabel.translatesAutoresizingMaskIntoConstraints = false

    loadingImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
    loadingImageView.bottomAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 50).active = true

    activityIndicator.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 5).active = true
    activityIndicator.topAnchor.constraintEqualToAnchor(loadingImageView.bottomAnchor, constant: 60).active = true

    upperTaglineConstraint = upperTaglineLabel.topAnchor.constraintEqualToAnchor(activityIndicator.bottomAnchor, constant: 100)
    upperTaglineConstraint?.active = true
    upperTaglineLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true

    lowerTaglineConstraint = lowerTaglineLabel.topAnchor.constraintEqualToAnchor(upperTaglineLabel.bottomAnchor, constant: 100)
    lowerTaglineConstraint?.active = true
    lowerTaglineLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    activityIndicator.startAnimating()
    fetchCategories()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    UIView.animateKeyframesWithDuration(0.9, delay: 0, options: [],
                                        animations: {
      UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.6) {
        self.upperTaglineLabel.alpha = 1
        self.upperTaglineConstraint?.constant = 40
        self.view.layoutIfNeeded()
      }
      UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.7) {
        self.lowerTaglineLabel.alpha = 1
        self.lowerTaglineConstraint?.constant = 0
        self.view.layoutIfNeeded()
      }
    }, completion: nil)
  }

  // MARK: - Private Methods

  private func fetchCategories() {
    Alamofire.request(.GET, iCookTVKeys.baseAPIURL + "categories.json").responseJSON { [weak self] response in
      guard let data = response.data where response.result.error == nil else {
        self?.showAlert(response.result.error)
        return
      }

      do {
        Debug.print(response.result.value)
        let json = try JSON(data: data)
        let categories = try json.array("data").map(Category.init)
        self?.navigationController?.setViewControllers([CategoriesViewController(categories: categories)], animated: true)
      } catch {
        self?.showAlert(error, retry: self?.fetchCategories)
      }
    }
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension UILabel {

  private class func taglineLabel() -> UILabel {
    let label = UILabel()
    label.font = UIFont.tvFontForTagline()
    label.textColor = UIColor.tvTaglineColor()
    label.textAlignment = .Center
    label.numberOfLines = 0
    label.alpha = 0
    return label
  }

}
