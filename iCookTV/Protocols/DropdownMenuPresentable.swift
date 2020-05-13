//
//  DropdownMenuPresentable.swift
//  TryTVOS
//
//  Created by Ben on 30/10/2016.
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

protocol DropdownMenuPresentable: class {
  /// A reference to the dropdown menu view.
  var dropdownMenuView: MenuView { get }

  /// Returns a configured menu view.
  static func defaultMenuView() -> MenuView

  /// Sets up the dropdown menu view at the top.
  func setUpDropdownMenuView()

  /// Shows or hides the dropdown menu view according to the context.
  func animateDropdownMenuView(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)
}


extension DropdownMenuPresentable where Self: UIViewController {

  static func defaultMenuView() -> MenuView {
    let menu = MenuView()
    menu.backgroundColor = UIColor.tvMenuBarColor()
    return menu
  }

  func setUpDropdownMenuView() {
    dropdownMenuView.frame = CGRect(x: 0, y: -140, width: view.bounds.width, height: 140)
    view.addSubview(dropdownMenuView)
  }

  func animateDropdownMenuView(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
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

}
