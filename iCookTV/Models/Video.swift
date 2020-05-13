//
//  Video.swift
//  TryTVOS
//
//  Created by Ben on 19/02/2016.
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

struct Video {

  let id: String
  let title: String
  let subtitle: String?
  let description: String?
  let length: Int
  let youtube: String
  let source: String?
  let cover: String

  var coverURL: URL? {
    return URL(string: cover)
  }

  var timestamp: String {
    let seconds = length % 60
    let minutes = (length / 60) % 60
    let hours = length / 3600
    return (hours > 0 ? "\(hours):" : "") + String(format: "%d:%02d", minutes, seconds)
  }

}


extension Video: Codable {

  private enum CodingKeys: String, CodingKey {
    case id
    case attributes
  }

  private enum AttributesCodingKeys: String, CodingKey {
    case title
    case subtitle
    case description
    case length
    case youtube = "embed-url"
    case source = "video-url"
    case cover = "cover-url"
  }

  // MARK: - Decodable

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)

    let attributes = try container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
    title = try attributes.decode(String.self, forKey: .title)
    subtitle = try? attributes.decode(String.self, forKey: .subtitle)
    description = try? attributes.decode(String.self, forKey: .description)
    length = (try? attributes.decode(Int.self, forKey: .length)) ?? 0
    youtube = try attributes.decode(String.self, forKey: .youtube)
    source = try? attributes.decode(String.self, forKey: .source)
    cover = try attributes.decode(String.self, forKey: .cover)
  }

  // MARK: - Encodable

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)

    var attributes = container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
    try attributes.encode(title, forKey: .title)
    try attributes.encode(length, forKey: .length)
    try attributes.encode(youtube, forKey: .youtube)
    try attributes.encode(cover, forKey: .cover)

    // Optional values
    try subtitle.map { try attributes.encode($0, forKey: .subtitle) }
    try description.map { try attributes.encode($0, forKey: .description) }
    try source.map { try attributes.encode($0, forKey: .source) }
  }

}
