//
//  CategoriesViewController.swift
//  TryTVOS
//
//  Created by Ben on 22/03/2016.
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

class CategoriesViewController: UIViewController,
  UICollectionViewDelegate,
  UICollectionViewDelegateFlowLayout,
  BlurBackgroundPresentable,
  Trackable {

  private var dataSource: CategoriesDataSource {
    didSet {
      collectionView.reloadData()
    }
  }

  private lazy var titleView: MainMenuView = {
    let _menu = MainMenuView()
    _menu.button.setTitle(NSLocalizedString("history", comment: ""), for: .normal)
    _menu.button.addTarget(self, action: .showHistory, for: .primaryActionTriggered)
    return _menu
  }()

  private(set) lazy var collectionView: UICollectionView = {
    let _collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: Metrics.showcaseLayout)
    _collectionView.register(cell: CategoryCell.self)
    _collectionView.remembersLastFocusedIndexPath = true
    _collectionView.dataSource = self.dataSource
    _collectionView.delegate = self
    return _collectionView
  }()

  // MARK: - BlurBackgroundPresentable

  let backgroundImageView = UIImageView()

  // MARK: - Initialization

  init(categories: [Category]) {
    dataSource = CategoriesDataSource(categories: categories)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    dataSource = CategoriesDataSource(categories: [])
    super.init(coder: aDecoder)
  }

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    setUpBlurBackground()
    navigationItem.titleView = UIView()

    let divided = view.bounds.divided(atDistance: 800, from: .maxYEdge)
    titleView.frame = divided.remainder
    titleView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
    collectionView.frame = divided.slice
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]

    view.addSubview(titleView)
    view.addSubview(collectionView)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(
      self,
      selector: .handleCreatedCover,
      name: NSNotification.Name(rawValue: CoverBuilder.DidCreateCoverNotification),
      object: nil
    )
  }

  // MARK: - UIFocusEnvironment

  override var preferredFocusedView: UIView? {
    return collectionView
  }

  // MARK: - UICollectionViewDelegate

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let category = dataSource[indexPath.row]
    let controller = VideosViewController(categoryID: category.id, title: category.name)
    navigationController?.pushViewController(controller, animated: true)
  }

  func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    if let cell = context.nextFocusedView as? CategoryCell, let cover = cell.imageView.image, cell.hasDisplayedCover {
      animateBackgroundTransition(to: cover)
    }
  }

  // MARK: - Trackable

  var pageView: PageView? {
    return PageView(name: "Categories")
  }

  // MARK: - NSNotification Callbacks

  @objc fileprivate func handleCreatedCover(_ notification: Notification) {
    // Update the background image when the first mosaic cover is created.
    if let cover = notification.userInfo?[CoverBuilder.NotificationUserInfoCoverKey] as? UIImage {
      DispatchQueue.main.async {
        self.animateBackgroundTransition(to: cover)
      }
    }
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: CoverBuilder.DidCreateCoverNotification), object: nil)
  }

  // MARK: - UIResponder Callbacks

  @objc fileprivate func showHistory(_ sender: UIButton) {
    navigationController?.pushViewController(HistoryViewController(), animated: true)
  }

  @objc fileprivate func updateBackground(with image: UIImage) {
    animateBackgroundTransition(to: image)
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension Selector {
  static let handleCreatedCover = #selector(CategoriesViewController.handleCreatedCover(_:))
  static let showHistory = #selector(CategoriesViewController.showHistory(_:))
  static let updateBackground = #selector(CategoriesViewController.updateBackground(with:))
}
