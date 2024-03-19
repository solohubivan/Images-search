//
//  PixabayData.swift
//  Images search
//
//  Created by Ivan Solohub on 03.03.2024.
//

import Foundation

struct PixabayData: Codable {
    var total: Int = 0
    var hits: [Hit] = []
}

struct Hit: Codable {
    var type: String
    var tags: String
    var webformatURL: String
    var largeImageURL: String
    var likes: Int?
    var downloads: Int?
    var views: Int?
    var comments: Int?
}
