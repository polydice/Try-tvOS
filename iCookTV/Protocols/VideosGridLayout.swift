//
//  VideosGridLayout.swift
//  iCookTV
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

protocol VideosGridLayout: class {
  /// A reference to the collection view.
  var collectionView: UICollectionView { get }

  /// Returns a configured collection view.
  static func defaultCollectionView(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) -> UICollectionView

  /// Sets up the collection view in the view hierarchy.
  func setUpCollectionView()
}


extension VideosGridLayout where Self: UIViewController {

  static func defaultCollectionView(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) -> UICollectionView {
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: Metrics.gridFlowLayout)
    collectionView.register(cell: VideoCell.self)
    collectionView.register(supplementaryView: SectionHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
    collectionView.remembersLastFocusedIndexPath = true
    collectionView.dataSource = dataSource
    collectionView.delegate = delegate
    return collectionView
  }

  func setUpCollectionView() {
    collectionView.frame = view.bounds
    view.addSubview(collectionView)
    if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: SectionHeaderView.requiredHeight)
    }
  }

}
