//
//  Category.swift
//  TryTVOS
//
//  Created by Ben on 25/03/2016.
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

struct Category {

  let id: String
  let name: String
  let coverURLs: [String]

}


extension Category: Codable {

  private enum CodingKeys: String, CodingKey {
    case id
    case attributes
  }

  private enum AttributesCodingKeys: String, CodingKey {
    case name
    case coverURLs = "cover-urls"
  }

  // MARK: - Decodable

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)

    let attributes = try container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
    name = try attributes.decode(String.self, forKey: .name)
    coverURLs = try attributes.decode([String].self, forKey: .coverURLs)
  }

  // MARK: - Encodable

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)

    var attributes = container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
    try attributes.encode(name, forKey: .name)
    try attributes.encode(coverURLs, forKey: .coverURLs)
  }

}
