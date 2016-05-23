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

class HistoryViewController: VideosViewController {

  // MARK: - UIViewController

  override var title: String? {
    get {
      return "History".localizedString
    }
    set {}
  }

  override func loadView() {
    super.loadView()
    dropdownMenuView.button.setTitle("Home".localizedString, forState: .Normal)
    dropdownMenuView.button.addTarget(self, action: .backToHome, forControlEvents: .PrimaryActionTriggered)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    isLoading = true
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      do {
        let history = try HistoryManager.history.map(Video.init)
        dispatch_sync(dispatch_get_main_queue()) {
          self.videos = history
          self.isLoading = false
        }
      } catch {
        Tracker.track(error)
        // Remove the malformed cache.
        HistoryManager.deleteCache() { _ in
          self.isLoading = false
        }
      }
      Tracker.track(PageView(name: "History", details: [
        TrackableKey.numberOfItems: self.videos.count
      ]))
    }
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if !videos.isEmpty {
      collectionView.reloadData()
    }
  }

  // MARK: - VideosViewController

  override var pagingTracking: Event? {
    return nil
  }

  // MARK: - UICollectionViewDelegate

  override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    // History doesn't need pagination.
  }

  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)

    let video = videos[indexPath.row]
    var reordered = videos
    reordered.removeAtIndex(indexPath.row)
    reordered.insert(video, atIndex: 0)

    // Reorder current displayed contents after the video player is presented.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      self.videos = reordered
    }
  }

  // MARK: - OverlayEnabled

  private lazy var emptyStateOverlay: UIView = {
    let _empty = EmptyStateView()
    _empty.textLabel.text = "You haven't watched any video.".localizedString
    return _empty
  }()

  override var overlayView: UIView {
    return emptyStateOverlay
  }

  // MARK: - Trackable

  override var pageView: PageView? {
    // Track History PV when the number of items is retrived.
    return nil
  }

  // MARK: - UIResponder Callbacks

  @objc private func backToHome(sender: UIButton) {
    navigationController?.popToRootViewControllerAnimated(true)
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension Selector {
  static let backToHome = #selector(HistoryViewController.backToHome(_:))
}
