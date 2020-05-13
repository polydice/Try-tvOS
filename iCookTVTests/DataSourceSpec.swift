//
//  DataSourceSpec.swift
//  TryTVOS
//
//  Created by Ben on 14/08/2016.
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

@testable import iCookTV
import UIKit
import XCTest

final class DataSourceSpec: XCTestCase {

  private struct TestCollection: DataCollection {
    typealias DataType = String
    private(set) var items: [String]
  }

  private var dataSource = DataSource(dataCollection: TestCollection(items: []))
  private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())

  override func setUp() {
    dataSource = DataSource(dataCollection: TestCollection(items: [
      "Lorem", "ipsum", "dolor", "sit", "amet"
    ]))
  }

  func testNumberOfItems() {
    // It should return the count of items
    XCTAssertEqual(dataSource.numberOfItems, 5)
  }

  func testSubscript() {
    // It should return the item at index
    XCTAssertEqual(dataSource[0], "Lorem")
    XCTAssertEqual(dataSource[1], "ipsum")
    XCTAssertEqual(dataSource[2], "dolor")
    XCTAssertEqual(dataSource[3], "sit")
    XCTAssertEqual(dataSource[4], "amet")
  }

  func testAppendItemsToCollectionView() {
    // Given
    let items = ["consectetur", "adipisicing", "elit"]

    // When
    dataSource.append(items, toCollectionView: collectionView)

    // It should append items to collection
    XCTAssertEqual(dataSource.numberOfItems, 8)
    XCTAssertEqual(dataSource[5], "consectetur")
    XCTAssertEqual(dataSource[6], "adipisicing")
    XCTAssertEqual(dataSource[7], "elit")
  }

  func testMoveItemAtIndexPathToTopInCollectionView() {
    // Given
    let indexPath = IndexPath(row: 2, section: 0)

    // When
    dataSource.moveItem(atIndexPathToTop: indexPath, inCollectionView: collectionView)

    // It should reorder the items
    XCTAssertEqual(dataSource.numberOfItems, 5)
    XCTAssertEqual(dataSource[0], "dolor")
    XCTAssertEqual(dataSource[1], "Lorem")
    XCTAssertEqual(dataSource[2], "ipsum")
    XCTAssertEqual(dataSource[3], "sit")
    XCTAssertEqual(dataSource[4], "amet")
  }

}
