//
//  VideoPlayerController.swift
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
import AVKit
import Alamofire
import Freddy

class VideoPlayerController: AVPlayerViewController, Trackable {

  private var video: Video?
  private var coverImage: UIImage?

  /// An activity indicator displayed before the player item is ready.
  private lazy var loadingIndicator: UIActivityIndicatorView = {
    let _indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    _indicator.hidesWhenStopped = true
    return _indicator
  }()

  private let playerItemNotifications = [
    NSNotification.Name.AVPlayerItemDidPlayToEndTime
  ]

  // MARK: - Initialization

  convenience init(video: Video, coverImage image: UIImage? = nil) {
    self.init(nibName: nil, bundle: nil)
    self.video = video
    self.coverImage = image
  }

  deinit {
    for notification in playerItemNotifications {
      NotificationCenter.default.removeObserver(self, name: notification, object: nil)
    }
  }

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    if let contentView = contentOverlayView {
      contentView.addSubview(loadingIndicator)
      loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
      // AVPlayerViewController's own indicator has a 5 pt offset from the center.
      loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -5).isActive = true
      loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    loadingIndicator.startAnimating()

    guard let id = video?.id else {
      setPlayerItem(nil)
      return
    }

    let url = iCookTVKeys.baseAPIURL + "videos/\(id).json"
    Alamofire.request(url, method: .get).responseJSON { [weak self] response in
      guard let data = response.data, response.result.error == nil else {
        self?.setPlayerItem(nil)
        Tracker.track(response.result.error)
        return
      }

      do {
        let json = try JSON(data: data)
        let video = try Video(json: json["data"] ?? nil)
        video.convertToPlayerItemWithCover(self?.coverImage) { [weak self] in
          self?.setPlayerItem($0)
        }
      } catch {
        Tracker.track(error)
        self?.setPlayerItem(nil)
      }
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    player?.pause()

    if let playerItem = player?.currentItem {
      let duration: TimeInterval = CMTimeGetSeconds(playerItem.duration)
      let currentTime: TimeInterval = CMTimeGetSeconds(playerItem.currentTime())
      let fraction = currentTime / duration

      Tracker.track(Event(name: "Played Video", details: [
        TrackableKey.videoID: NSString(format: "%@", video?.id ?? ""),
        TrackableKey.videoTitle: NSString(format: "%@", video?.title ?? ""),
        TrackableKey.currentTime: NSNumber(value: currentTime),
        TrackableKey.duration: NSNumber(value: duration),
        TrackableKey.percentage: NSNumber(value: fraction * 100)
      ]))
    }
  }

  // MARK: - Trackable

  var pageView: PageView? {
    return PageView(name: "Player", details: [
      TrackableKey.videoID: video?.id ?? "",
      TrackableKey.videoTitle: video?.title ?? ""
    ])
  }

  // MARK: - NSNotification Callbacks

  @objc fileprivate func handlePlayerItemNotification(_ notification: Notification) {
    switch notification.name {
    case NSNotification.Name.AVPlayerItemDidPlayToEndTime:
      dismiss()
    default:
      break
    }
  }

  // MARK: - Private Methods

  private func dismiss() {
    if let navigation = navigationController {
      navigation.popViewController(animated: true)
    } else if let presenter = presentingViewController {
      presenter.dismiss(animated: true, completion: nil)
    }
  }

  private func setPlayerItem(_ playerItem: AVPlayerItem?) {
    loadingIndicator.stopAnimating()

    guard let playerItem = playerItem else {
      let message = NSLocalizedString("video-error", comment: "") + "\n" + NSLocalizedString("contact-info", comment: "")
      let alert = UIAlertController(title: NSLocalizedString("error-title", comment: ""), message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { [weak self] _ in
        self?.dismiss()
      })
      present(alert, animated: true, completion: nil)
      return
    }

    for notification in playerItemNotifications {
      NotificationCenter.default.addObserver(
        self,
        selector: .handlePlayerItemNotification,
        name: notification,
        object: playerItem
      )
    }

    player = AVPlayer(playerItem: playerItem)
    player?.play()
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension Selector {
  static let handlePlayerItemNotification = #selector(VideoPlayerController.handlePlayerItemNotification(_:))
}
