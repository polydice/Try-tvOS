//
//  OverlayViewPresentable.swift
//  iCookTV
//
//  Created by Ben on 28/04/2016.
//  Copyright © 2016 Polydice, Inc.
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

protocol OverlayViewPresentable {
  /// A view used as the decorative overlay.
  var overlayView: UIView { get }

  /// Provides the superview of a given overlay view.
  func containerViewForOverlayView(_ overlayView: UIView) -> UIView

  /// Provides the constraints for a given overlay view.
  func constraintsForOverlayView(_ overlayView: UIView) -> [NSLayoutConstraint]

  /// Required method to update the background image behind the overlay view.
  func updateBackground(with image: UIImage?)
}


extension OverlayViewPresentable where Self: UIViewController {

  func setOverlayViewHidden(_ hidden: Bool, animated: Bool) {
    if !hidden {
      layoutOverlayViewIfNeeded()
      overlayView.superview?.bringSubviewToFront(overlayView)
    }

    let transition = {
      self.overlayView.alpha = hidden ? 0 : 1
    }

    if animated {
      UIView.animate(withDuration: 0.3, animations: transition)
    } else {
      transition()
    }

    if let url = GroundControl.defaultBackgroundURL, !hidden {
      KingfisherManager.shared.downloader.downloadImage(with: url, completionHandler: { [weak self] image, _, _, _ in
        self?.updateBackground(with: image)
      })
    }
  }

  private func layoutOverlayViewIfNeeded() {
    if overlayView.superview != nil {
      return
    }

    containerViewForOverlayView(overlayView).addSubview(overlayView)
    overlayView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(constraintsForOverlayView(overlayView))
  }

}
