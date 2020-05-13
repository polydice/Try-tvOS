//
//  BlurBackgroundPresentable.swift
//  TryTVOS
//
//  Created by Ben on 25/10/2016.
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

protocol BlurBackgroundPresentable: class {
  /// A reference to the background image view.
  var backgroundImageView: UIImageView { get }

  /// Sets up the background image view with a blur effect on top of it.
  func setUpBlurBackground()

  /// Animates the image transition of the background image view.
  func animateBackgroundTransition(to image: UIImage?)
}


extension BlurBackgroundPresentable where Self: UIViewController {

  func setUpBlurBackground() {
    view.backgroundColor = UIColor.tvBackgroundColor()

    backgroundImageView.frame = view.bounds
    backgroundImageView.contentMode = .scaleAspectFill
    backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    view.insertSubview(backgroundImageView, at: 0)
    view.insertSubview(blurEffectView, at: 1)
  }

  func animateBackgroundTransition(to image: UIImage?) {
    // Throttle background image transition to avoid extensive changes in a short period of time.
    let selector = #selector(UIImageView.transition(to:))
    NSObject.cancelPreviousPerformRequests(withTarget: backgroundImageView)
    backgroundImageView.perform(selector, with: image, afterDelay: 0.2)
  }

}


////////////////////////////////////////////////////////////////////////////////


extension UIImageView {

  @objc fileprivate func transition(to image: UIImage?) {
    Debug.print(#function)
    UIView.transition(
      with: self,
      duration: 0.5,
      options: [.beginFromCurrentState, .transitionCrossDissolve, .curveEaseIn],
      animations: {
        self.image = image
      }, completion: nil
    )
  }

}
