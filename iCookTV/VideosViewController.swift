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

class VideosViewController: BlurBackgroundViewController,
  UICollectionViewDataSource,
  UICollectionViewDelegate,
  UICollectionViewDelegateFlowLayout,
  OverlayEnabled,
  Trackable {

  var videos = [Video]() {
    didSet {
      collectionView.reloadData()
      setOverlayViewHidden(!videos.isEmpty, animated: true)
    }
  }

  var pagingTracking: Event? {
    return Event(name: "Fetched Page", details: [
      TrackableKey.categoryID: categoryID,
      TrackableKey.categoryTitle: title ?? "",
      TrackableKey.page: String(currentPage)
    ])
  }

  // MARK: - Private Properties

  private var categoryID = ""

  private(set) lazy var dropdownMenuView: MenuView = {
    let _menu = MenuView(frame: CGRect(x: 0, y: -140, width: self.view.bounds.width, height: 140))
    _menu.backgroundColor = UIColor.tvMenuBarColor()
    return _menu
  }()

  private(set) lazy var collectionView: UICollectionView = {
    let _collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: Metrics.gridFlowLayout)
    _collectionView.registerClass(VideoCell.self, forCellWithReuseIdentifier: NSStringFromClass(VideoCell.self))
    _collectionView.remembersLastFocusedIndexPath = true
    _collectionView.dataSource = self
    _collectionView.delegate = self
    return _collectionView
  }()

  private weak var currentRequest: Request?
  private let paginationQueue = dispatch_queue_create("io.github.bcylin.paginationQueue", DISPATCH_QUEUE_SERIAL)
  private var hasNextPage = true

  private var currentPage: Int {
    return Int(videos.count / self.dynamicType.pageSize)
  }

  private static let pageSize = 20

  // MARK: - Initialization

  convenience init(categoryID: String, title: String? = nil) {
    self.init(nibName: nil, bundle: nil)
    self.categoryID = categoryID
    self.title = title
  }

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    view.backgroundColor = UIColor.tvBackgroundColor()
    collectionView.frame = view.bounds
    view.addSubview(collectionView)
    view.addSubview(dropdownMenuView)

    dropdownMenuView.button.setTitle("History".localizedString, forState: .Normal)
    dropdownMenuView.button.addTarget(self, action: .showHistory, forControlEvents: .PrimaryActionTriggered)

    if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: CategoryHeaderView.requiredHeight)
    }

    collectionView.registerClass(
      CategoryHeaderView.self,
      forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
      withReuseIdentifier: String(CategoryHeaderView.self)
    )
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    if categoryID.isEmpty {
      setOverlayViewHidden(false, animated: true)
      return
    }
    fetchNextPage()
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    guard let stack = navigationController?.viewControllers else {
      return
    }
    // Track the event when popped off the navigation stack.
    if let event = pagingTracking where !stack.contains(self) {
      Tracker.track(event)
    }
  }

  // MARK: - UIFocusEnvironment

  override var preferredFocusedView: UIView? {
    return collectionView
  }

  override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    if context.nextFocusedView == dropdownMenuView.button {
      let revealedFrame = CGRect(origin: CGPoint.zero, size: dropdownMenuView.frame.size)
      coordinator.addCoordinatedAnimations({
        self.dropdownMenuView.frame = revealedFrame
      }, completion: nil)
    } else if context.previouslyFocusedView == dropdownMenuView.button {
      let hiddenFrame = dropdownMenuView.frame.offsetBy(dx: 0, dy: -dropdownMenuView.frame.height)
      coordinator.addCoordinatedAnimations({
        self.dropdownMenuView.frame = hiddenFrame
      }, completion: nil)
    }
  }

  // MARK: - UICollectionViewDataSource

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return videos.count
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(VideoCell.self), forIndexPath: indexPath)
    (cell as? VideoCell)?.configure(withVideo: videos[indexPath.row])
    return cell
  }

  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionHeader {
      let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(
        UICollectionElementKindSectionHeader,
        withReuseIdentifier: String(CategoryHeaderView.self),
        forIndexPath: indexPath
      )
      (headerView as? CategoryHeaderView)?.accessoryLabel.text = title ?? "Category"
      return headerView
    }

    return UICollectionReusableView()
  }

  // MARK: - UICollectionViewDelegate

  func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == videos.count - 1 && hasNextPage {
      fetchNextPage()
    }
  }

  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let video = videos[indexPath.row]
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as? VideoCell

    let controller = VideoPlayerController(video: video, coverImage: cell?.imageView.image)
    navigationController?.pushViewController(controller, animated: true)
    HistoryManager.save(video: video)
  }

  func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    if let cover = (context.nextFocusedView as? VideoCell)?.imageView.image {
      self.backgroundImage = cover
    }
  }

  // MARK: - OverlayEnabled

  private lazy var emptyStateOverlay: UIView = { EmptyStateView() }()

  var overlayView: UIView {
    return emptyStateOverlay
  }

  func containerViewForOverlayView(overlayView: UIView) -> UIView {
    return view
  }

  func constraintsForOverlayView(overlayView: UIView) -> [NSLayoutConstraint] {
    return [
      overlayView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      overlayView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
    ]
  }

  // MARK: - Trackable

  var pageView: PageView?{
    return PageView(name: "Videos", details: [
      TrackableKey.categoryID: categoryID,
      TrackableKey.categoryTitle: title ?? ""
    ])
  }

  // MARK: - UIResponder Callbacks

  @objc private func showHistory(sender: UIButton) {
    navigationController?.pushViewController(HistoryViewController(), animated: true)
  }

  // MARK: - Private Methods

  private func fetchNextPage() {
    if let _ = currentRequest {
      return
    }

    isLoading = videos.isEmpty

    let url = iCookTVKeys.baseAPIURL + "categories/\(categoryID)/videos.json"
    let parameters = [
      "page[size]": self.dynamicType.pageSize,
      "page[number]": currentPage + 1
    ]

    currentRequest = Alamofire.request(.GET, url, parameters: parameters).responseJSON { [weak self] response in
      self?.isLoading = false

      guard let data = response.data where response.result.error == nil else {
        self?.showAlert(response.result.error)
        return
      }

      guard let pagination = self?.paginationQueue else {
        return
      }

      var videos = self?.videos ?? []
      dispatch_async(pagination) {
        do {
          let json = try JSON(data: data)
          videos += try json.array("data").map(Video.init)

          dispatch_sync(dispatch_get_main_queue()) {
            self?.hasNextPage = json["links"]?["next"] != nil
            self?.videos = videos
          }
        } catch {
          dispatch_sync(dispatch_get_main_queue()) {
            self?.showAlert(error, retry: self?.fetchNextPage)
          }
        }
      }
    }
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension Selector {
  static let showHistory = #selector(VideosViewController.showHistory(_:))
}
