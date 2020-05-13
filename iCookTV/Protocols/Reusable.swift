//
//  Reusable.swift
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

protocol Reusable: class {
  /// A string identifying the view object to be reused.
  static var reuseIdentifier: String { get }
}


extension Reusable {

  static var reuseIdentifier: String {
    return String(describing: self)
  }

}


////////////////////////////////////////////////////////////////////////////////


extension UICollectionReusableView: Reusable {}

extension UICollectionView {

  func register<T: UICollectionViewCell>(cell type: T.Type) {
    register(type, forCellWithReuseIdentifier: type.reuseIdentifier)
  }

  func register<T: UICollectionReusableView>(supplementaryView type: T.Type, ofKind kind: String) {
    register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: type.reuseIdentifier)
  }

  func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type = T.self, for indexPath: IndexPath) -> T {
    if let cell = dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as? T {
      return cell
    } else {
      return type.init()
    }
  }

  func dequeueReusableSupplementaryView<T: UICollectionReusableView>(type: T.Type = T.self, ofKind kind: String, for indexPath: IndexPath) -> T {
    if let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.reuseIdentifier, for: indexPath) as? T {
      return view
    } else {
      return type.init()
    }
  }

}
