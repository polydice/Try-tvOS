//
//  Metrics.swift
//  TryTVOS
//
//  Created by Ben on 28/02/2016.
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

struct Metrics {

  static let EdgePadding = UIEdgeInsets(top: 60, left: 90, bottom: 60, right: 90)

  static var horizontalFlowLayout: UICollectionViewFlowLayout {
    let _horizontal = UICollectionViewFlowLayout()
    _horizontal.scrollDirection = .Horizontal
    _horizontal.sectionInset = UIEdgeInsets(top: 0, left: EdgePadding.left, bottom: 0, right: EdgePadding.right)
    _horizontal.minimumInteritemSpacing = 0
    _horizontal.minimumLineSpacing = 50
    _horizontal.itemSize = CGSize(width: 308, height: 308)
    return _horizontal
  }

  static var verticalFlowLayout: UICollectionViewFlowLayout {
    let _vertical = UICollectionViewFlowLayout()
    _vertical.scrollDirection = .Vertical
    _vertical.sectionInset = UIEdgeInsetsZero
    _vertical.minimumInteritemSpacing = 0
    _vertical.minimumLineSpacing = 50
    _vertical.headerReferenceSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 100)
    _vertical.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 308)
    return _vertical
  }

  static var gridFlowLayout: UICollectionViewFlowLayout {
    let _grid = UICollectionViewFlowLayout()
    _grid.scrollDirection = .Vertical
    _grid.sectionInset = UIEdgeInsets(top: 90, left: 80, bottom: 90, right: 80)
    _grid.minimumInteritemSpacing = 40
    _grid.minimumLineSpacing = 130

    let numberOfItemsPerRow = 5
    let paddings = EdgePadding.left + EdgePadding.right
    let spaces = _grid.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1)
    let contentWidth = UIScreen.mainScreen().bounds.width - paddings - spaces
    let itemWidth = contentWidth / CGFloat(numberOfItemsPerRow)
    _grid.itemSize = CGSize(width: itemWidth, height: 200)

    return _grid
  }

  static var showcaseLayout: UICollectionViewFlowLayout {
    let _showcase = UICollectionViewFlowLayout()
    _showcase.scrollDirection = .Horizontal
    _showcase.sectionInset = UIEdgeInsets(top: 100, left: 100, bottom: 220, right: 100)
    _showcase.minimumLineSpacing = 80
    _showcase.itemSize = CGSize(width: 640, height: 480)
    return _showcase
  }

}
