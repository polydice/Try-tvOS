//
//  LoadingIndicatorPresentable.swift
//  TryTVOS
//
//  Created by Ben on 29/10/2016.
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

protocol LoadingIndicatorPresentable: class {
  /// A reference to the background image view.
  var loadingIndicator: UIActivityIndicatorView { get }

  /// Toggles the loading indicator.
  var isLoading: Bool { get set }

  /// Returns a configured loading indicator.
  static func defaultLoadingIndicator() -> UIActivityIndicatorView

  /// Sets up the activity indicator view in the center of view.
  func setUpLoadingIndicator()
}


extension LoadingIndicatorPresentable where Self: UIViewController {

  var isLoading: Bool {
    get {
      return loadingIndicator.isAnimating
    }
    set {
      if newValue {
        loadingIndicator.startAnimating()
      } else {
        loadingIndicator.stopAnimating()
      }
    }
  }

  static func defaultLoadingIndicator() -> UIActivityIndicatorView {
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    indicator.color = UIColor.Palette.GreyishBrown
    indicator.hidesWhenStopped = true
    return indicator
  }

  func setUpLoadingIndicator() {
    view.addSubview(loadingIndicator)
    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }

}
