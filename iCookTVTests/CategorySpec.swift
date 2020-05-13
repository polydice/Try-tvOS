//
//  CategorySpec.swift
//  iCookTV
//
//  Created by Ben on 26/04/2016.
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

@testable import iCookTV
import XCTest

final class CategorySpec: XCTestCase {

  func testDecoding() throws {
    // Given Category.json
    let data: Data = Resources.testData(named: "Category.json")!

    // When decoding
    let decoder = JSONDecoder()
    let category = try decoder.decode(Category.self, from: data)

    // It should parse JSON as Category
    XCTAssertEqual(category.id, "9527")
    XCTAssertEqual(category.name, "愛料理廚房")
    XCTAssertEqual(category.coverURLs, [
      "https://imag.es/1.jpg",
      "https://imag.es/2.jpg",
      "https://imag.es/3.jpg",
      "https://imag.es/4.jpg"
    ])
  }

  func testEncoding() throws {
    // Given a Category object
    let category = Category(
      id: "9527",
      name: "愛料理廚房",
      coverURLs: [
        "https://imag.es/1.jpg",
        "https://imag.es/2.jpg"
      ]
    )

    // When encoding
    let encoder = JSONEncoder()
    let json = try encoder.encode(category)
    let jsonString = String(data: json, encoding: .utf8)

    // It should encode Category to JSON
    XCTAssert(jsonString!.contains("\"id\":\"9527\""))
    XCTAssert(jsonString!.contains("\"attributes\":{"))
    XCTAssert(jsonString!.contains("\"name\":\"愛料理廚房\""))
    XCTAssert(jsonString!.contains("\"cover-urls\":[\"https:\\/\\/imag.es\\/1.jpg\",\"https:\\/\\/imag.es\\/2.jpg\"]"))
  }

}
