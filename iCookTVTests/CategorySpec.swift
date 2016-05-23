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
import Freddy
import Nimble
import Quick

class CategorySpec: QuickSpec {

  override func spec() {

    let data: NSData = Resources.testData(named: "Category.json")!

    describe("init(json:)") {
      it("should parse JSON as Category") {
        let json = try! JSON(data: data)
        let category = try! Category(json: json)

        expect(category.id).to(equal("9527"))
        expect(category.name).to(equal("愛料理廚房"))
        expect(category.coverURLs).to(equal([
          "https://imag.es/1.jpg",
          "https://imag.es/2.jpg",
          "https://imag.es/3.jpg",
          "https://imag.es/4.jpg"
        ]))
      }
    }

  }

}
