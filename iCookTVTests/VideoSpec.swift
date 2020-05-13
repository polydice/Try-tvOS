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
import XCTest

final class VideoSpec: XCTestCase {

  func testDecoding() throws {
    // Given Video.json
    let data: Data = Resources.testData(named: "Video.json")!

    // When decoding
    let decoder = JSONDecoder()
    let video = try! decoder.decode(Video.self, from: data)

    // It should parse JSON as Video
    XCTAssertEqual(video.id, "42")
    XCTAssertEqual(video.title, "Lorem")
    XCTAssertEqual(video.subtitle, "ipsum")
    XCTAssertEqual(video.description, "dolor sit amet")
    XCTAssertEqual(video.length, 123)
    XCTAssertEqual(video.youtube, "https://www.youtube.com/watch?v=3345678")
    XCTAssertEqual(video.source, "https://vide.os/source.m3u8")
    XCTAssertEqual(video.cover, "https://imag.es/cover.jpg")
  }

  func testEncoding() throws {
    // Given a Video object
    let video = Video(
      id: "42",
      title: "Lorem",
      subtitle: "ipsum",
      description: "dolor sit amet",
      length: 123,
      youtube: "https://www.youtube.com/watch?v=3345678",
      source: "https://vide.os/source.m3u8",
      cover: "https://imag.es/cover.jpg"
    )

    // When encoding
    let encoder = JSONEncoder()
    let json = try encoder.encode(video)
    let jsonString = String(data: json, encoding: .utf8)

    // It should encode Video to JSON
    XCTAssert(jsonString!.contains("\"id\":\"42\""))
    XCTAssert(jsonString!.contains("\"title\":\"Lorem\""))
    XCTAssert(jsonString!.contains("\"subtitle\":\"ipsum\""))
    XCTAssert(jsonString!.contains("\"description\":\"dolor sit amet\""))
    XCTAssert(jsonString!.contains("\"length\":123"))
    XCTAssert(jsonString!.contains("\"embed-url\":\"https:\\/\\/www.youtube.com\\/watch?v=3345678\""))
    XCTAssert(jsonString!.contains("\"video-url\":\"https:\\/\\/vide.os\\/source.m3u8\""))
    XCTAssert(jsonString!.contains("\"cover-url\":\"https:\\/\\/imag.es\\/cover.jpg\""))
  }

}
