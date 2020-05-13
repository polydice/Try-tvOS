//
//  DataCollectionSpec.swift
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
import XCTest

final class DataCollectionSpec: XCTestCase {

  private struct TestCollection: DataCollection {
    typealias DataType = Int
    private(set) var items: [Int]
  }

  private var dataCollection = TestCollection(items: [])

  override func setUp() {
    dataCollection = TestCollection(items: [1, 1, 2, 3, 5, 8])
  }

  func testCount() {
    // It should return the count of items
    XCTAssertEqual(dataCollection.count, 6)
  }

  func testSubscript() {
    // It should return the item at index
    XCTAssertEqual(dataCollection[0], 1)
    XCTAssertEqual(dataCollection[1], 1)
    XCTAssertEqual(dataCollection[2], 2)
    XCTAssertEqual(dataCollection[3], 3)
    XCTAssertEqual(dataCollection[4], 5)
    XCTAssertEqual(dataCollection[5], 8)
  }

  func testAppendItems() {
    // Given
    let newItems = [13, 21, 34, 55]

    // When
    let newCollection = dataCollection.append(newItems)

    // Then the original data collection should remain the same
    XCTAssertEqual(dataCollection.count, 6)

    // It should append items to the new collection
    XCTAssertEqual(newCollection.count, 10)
    XCTAssertEqual(newCollection[6], 13)
    XCTAssertEqual(newCollection[7], 21)
    XCTAssertEqual(newCollection[8], 34)
    XCTAssertEqual(newCollection[9], 55)
  }

  func testInsertItemAtIndex() {
    // When
    let newCollection = dataCollection.insert(42, atIndex: 3)

    // Then the original data collection should remain the same
    XCTAssertEqual(dataCollection.count, 6)

    // It should insert item to the new collection
    XCTAssertEqual(newCollection.count, 7)
    XCTAssertEqual(newCollection.items, [1, 1, 2, 42, 3, 5, 8])
  }

  func testDeleteItemAtIndex() {
    // When
    let newCollection = dataCollection.deleteItem(atIndex: 3)

    // Then the original data collection should remain the same
    XCTAssertEqual(dataCollection.count, 6)

    // It should delete item at index in the new collection
    XCTAssertEqual(newCollection.count, 5)
    XCTAssertEqual(newCollection.items, [1, 1, 2, 5, 8])
  }

  func testMoveItemFromIndexToIndex() {
    // When
    let newCollection = dataCollection.moveItem(fromIndex: 1, toIndex: 4)

    // Then the original data collection should remain the same
    XCTAssertEqual(dataCollection.count, 6)

    // It should reorder the items in the new collection
    XCTAssertEqual(newCollection.count, 6)
    XCTAssertEqual(newCollection.items, [1, 2, 3, 5, 1, 8])
  }

}
