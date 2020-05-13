//
//  DataCollection.swift
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

import Foundation

protocol DataCollection {

  associatedtype DataType

  init(items: [DataType])

  var items: [DataType] { get }
  var count: Int { get }

  subscript(index: Int) -> DataType { get }

  func append(_ items: [DataType]) -> Self
  func insert(_ item: DataType, atIndex index: Int) -> Self
  func deleteItem(atIndex index: Int) -> Self
  func moveItem(fromIndex: Int, toIndex: Int) -> Self
}


////////////////////////////////////////////////////////////////////////////////


extension DataCollection {

  var count: Int {
    return items.count
  }

  subscript(index: Int) -> DataType {
    return items[index]
  }

  func append(_ items: [DataType]) -> Self {
    var mutableCollection = self.items
    mutableCollection += items
    return Self(items: mutableCollection)
  }

  func insert(_ item: DataType, atIndex index: Int) -> Self {
    var mutableCollection = items
    mutableCollection.insert(item, at: index)
    return Self(items: mutableCollection)
  }

  func deleteItem(atIndex index: Int) -> Self {
    var mutableCollection = items
    mutableCollection.remove(at: index)
    return Self(items: mutableCollection)
  }

  func moveItem(fromIndex: Int, toIndex: Int) -> Self {
    return deleteItem(atIndex: fromIndex).insert(items[fromIndex], atIndex: toIndex)
  }

}
