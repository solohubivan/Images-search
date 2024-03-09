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
}
//    var previewURL: String
//    var previewWidth: Int
//    var previewHeight: Int?
//    var webformatURL: String?
//    var webformatWidth: Int?
//    var webformatHeight: Int?
//    var largeImageURL: String?
//    var imageURL: String?
//    var imageWidth: Int?
//    var imageHeight: Int?
//    var imageSize: Int?
//    var views: Int?
//    var downloads: Int?
//    var collections: Int?
//    var likes: Int?
//    var userImageURL: String?

