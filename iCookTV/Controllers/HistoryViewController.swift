//
//  HistoryViewController.swift
//  TryTVOS
//
//  Created by Ben on 21/04/2016.
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

class HistoryViewController: UIViewController,
  UICollectionViewDelegate,
  UICollectionViewDelegateFlowLayout,
  BlurBackgroundPresentable,
  DropdownMenuPresentable,
  LoadingIndicatorPresentable,
  OverlayViewPresentable,
  VideosGridLayout {

  private let dataSource = VideosDataSource()

  // MARK: - BlurBackgroundPresentable

  let backgroundImageView = UIImageView()

  // MARK: - DropdownMenuPresentable

  private(set) lazy var dropdownMenuView: MenuView = type(of: self).defaultMenuView()

  // MARK: - LoadingIndicatorPresentable

  private(set) lazy var loadingIndicator: UIActivityIndicatorView = type(of: self).defaultLoadingIndicator()

  // MARK: - VideosGridLayout

  private(set) lazy var collectionView: UICollectionView = type(of: self).defaultCollectionView(dataSource: self.dataSource, delegate: self)

  // MARK: - UIViewController

  override var title: String? {
    get {
      return NSLocalizedString("history", comment: "")
    }
    set {}
  }

  override func loadView() {
    super.loadView()
    setUpBlurBackground()
    setUpCollectionView()
    setUpDropdownMenuView()
    dropdownMenuView.button.setTitle(NSLocalizedString("home", comment: ""), for: .normal)
    dropdownMenuView.button.addTarget(self, action: .backToHome, for: .primaryActionTriggered)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setOverlayViewHidden(false, animated: false)
    isLoading = true
    DispatchQueue.global().async {
      do {
        let history = try HistoryManager.history.map(Video.init)
        DispatchQueue.main.sync {
          self.dataSource.append(history, toCollectionView: self.collectionView)
          self.setOverlayViewHidden(self.dataSource.numberOfItems > 0, animated: true)
          self.isLoading = false
        }
      } catch {
        Tracker.track(error)
        // Remove the malformed cache.
        HistoryManager.deleteCache { _ in
          self.isLoading = false
        }
      }
      Tracker.track(PageView(name: "history", details: [
        TrackableKey.numberOfItems: NSNumber(value: self.dataSource.numberOfItems)
      ]))
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if dataSource.numberOfItems > 0 {
      collectionView.reloadData()
    }
  }

  // MARK: - UIFocusEnvironment

  override var preferredFocusedView: UIView? {
    return collectionView
  }

  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    animateDropdownMenuView(in: context, with: coordinator)
  }

  // MARK: - UICollectionViewDelegate

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // Reorder current displayed contents after the video player is presented.
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
      self.dataSource.moveItem(atIndexPathToTop: indexPath, inCollectionView: collectionView)
    }
  }

  // MARK: - OverlayViewPresentable

  private(set) lazy var overlayView: UIView = {
    let _empty = EmptyStateView()
    _empty.textLabel.text = NSLocalizedString("no-history-found", comment: "")
    return _empty
  }()

  func containerViewForOverlayView(_ overlayView: UIView) -> UIView {
    return view
  }

  func constraintsForOverlayView(_ overlayView: UIView) -> [NSLayoutConstraint] {
    return [
      overlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      overlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ]
  }

  func updateBackground(with image: UIImage?) {
    animateBackgroundTransition(to: image)
  }

  // MARK: - UIResponder Callbacks

  @objc fileprivate func backToHome(_ sender: UIButton) {
    _ = navigationController?.popToRootViewController(animated: true)
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension Selector {
  static let backToHome = #selector(HistoryViewController.backToHome(_:))
}
