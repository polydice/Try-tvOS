//
//  VideosViewController.swift
//  TryTVOS
//
//  Created by Ben on 15/03/2016.
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
import Keys

class VideosViewController: UIViewController,
  UICollectionViewDelegate,
  UICollectionViewDelegateFlowLayout,
  BlurBackgroundPresentable,
  DataFetching,
  DropdownMenuPresentable,
  LoadingIndicatorPresentable,
  OverlayViewPresentable,
  Trackable,
  VideosGridLayout {

  private var categoryID = ""

  private lazy var dataSource: VideosDataSource = {
    VideosDataSource(categoryID: self.categoryID, title: self.title)
  }()

  private var pagingTracking: Event? {
    return Event(name: "Fetched Page", details: [
      TrackableKey.categoryID: categoryID,
      TrackableKey.categoryTitle: title ?? "",
      TrackableKey.page: String(dataSource.currentPage)
    ])
  }

  // MARK: - BlurBackgroundPresentable

  let backgroundImageView = UIImageView()

  // MARK: - DataFetching

  let pagination = Pagination(name: "io.github.bcylin.pagination.videos")

  // MARK: - DropdownMenuPresentable

  private(set) lazy var dropdownMenuView: MenuView = type(of: self).defaultMenuView()

  // MARK: - LoadingIndicatorPresentable

  private(set) lazy var loadingIndicator: UIActivityIndicatorView = type(of: self).defaultLoadingIndicator()

  // MARK: - VideosGridLayout

  private(set) lazy var collectionView: UICollectionView = type(of: self).defaultCollectionView(dataSource: self.dataSource, delegate: self)

  // MARK: - Initialization

  convenience init(categoryID: String, title: String? = nil) {
    self.init(nibName: nil, bundle: nil)
    self.categoryID = categoryID
    self.title = title
  }

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    setUpBlurBackground()
    setUpCollectionView()
    setUpDropdownMenuView()
    dropdownMenuView.button.setTitle(R.string.localizable.history(), for: .normal)
    dropdownMenuView.button.addTarget(self, action: .showHistory, for: .primaryActionTriggered)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    if categoryID.isEmpty {
      setOverlayViewHidden(false, animated: true)
      return
    }
    fetchNextPage()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    guard let stack = navigationController?.viewControllers else {
      return
    }
    // Track the event when popped off the navigation stack.
    if let event = pagingTracking, !stack.contains(self) {
      Tracker.track(event)
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

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.row == dataSource.numberOfItems - 1 {
      fetchNextPage()
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let video = dataSource[indexPath.row]
    let cell = collectionView.cellForItem(at: indexPath) as? VideoCell

    let controller = VideoPlayerController(video: video, coverImage: cell?.imageView.image)
    navigationController?.pushViewController(controller, animated: true)
    HistoryManager.save(video: video)
  }

  func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    if let cover = (context.nextFocusedView as? VideoCell)?.imageView.image {
      animateBackgroundTransition(to: cover)
    }
  }

  // MARK: - OverlayViewPresentable

  private(set) lazy var overlayView: UIView = { EmptyStateView() }()

  func containerViewForOverlayView(_ overlayView: UIView) -> UIView {
    return view
  }

  func constraintsForOverlayView(_ overlayView: UIView) -> [NSLayoutConstraint] {
    return [
      overlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      overlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ]
  }

  @objc func updateBackground(with image: UIImage?) {
    animateBackgroundTransition(to: image)
  }

  // MARK: - Trackable

  var pageView: PageView? {
    return PageView(name: "Videos", details: [
      TrackableKey.categoryID: categoryID,
      TrackableKey.categoryTitle: title ?? ""
    ])
  }

  // MARK: - UIResponder Callbacks

  @objc fileprivate func showHistory(_ sender: UIButton) {
    navigationController?.pushViewController(HistoryViewController(), animated: true)
  }

  // MARK: - Private Methods

  private func fetchNextPage() {
    guard pagination.isReady else {
      return
    }

    isLoading = (dataSource.numberOfItems == 0)
    fetch(request: dataSource.requestForNextPage) { [weak self] (result: Result<[Video]>) in
      _ = result
        .mapSuccess { [weak self] videos in
          guard let current = self else {
            return
          }
          self?.dataSource.append(videos, toCollectionView: current.collectionView)
          self?.setOverlayViewHidden(current.dataSource.numberOfItems > 0, animated: true)
        }
        .mapError { [weak self] error in
          self?.showAlert(error, retry: self?.fetchNextPage)
        }
    }
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension Selector {
  static let showHistory = #selector(VideosViewController.showHistory(_:))
  static let updateBackground = #selector(VideosViewController.updateBackground(with:))
}
