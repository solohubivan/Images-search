//
//  FoundImagesViewModel.swift
//  Images search
//
//  Created by Ivan Solohub on 05.03.2024.
//

import Foundation

struct FoundImagesViewModel: Codable {
    var type: String
    var tags: String
    var webformatUrl: String
    var largeImageUrl: String
}
