//
//  VideoSpec.swift
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

class VideoSpec: QuickSpec {

  override func spec() {

    let data: NSData = Resources.testData(named: "Video.json")!
    let json = try! JSON(data: data)
    let video = try! Video(json: json)

    describe("init(json:)") {
      it("should parse JSON as Video") {
        expect(video.id).to(equal("42"))
        expect(video.title).to(equal("Lorem"))
        expect(video.subtitle).to(equal("ipsum"))
        expect(video.description).to(equal("dolor sit amet"))
        expect(video.length).to(equal(123))
        expect(video.youtube).to(equal("https://www.youtube.com/watch?v=3345678"))
        expect(video.source).to(equal("https://vide.os/source.m3u8"))
        expect(video.cover).to(equal("https://imag.es/cover.jpg"))
      }
    }

    describe("toJSON()") {
      let converted = video.toJSON()

      it("should convert Video to JSON") {
        expect(converted["id"]).to(equal(json["id"]))

        for key in ["title", "embed-url", "video-url", "cover-url", "length", "subtitle", "description"] {
          expect(converted["attributes"]?[key]).to(equal(json["attributes"]?[key]))
        }
      }
    }

  }

}
