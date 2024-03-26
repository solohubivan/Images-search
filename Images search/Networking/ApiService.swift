//
//  ApiService.swift
//  Images search
//
//  Created by Ivan Solohub on 21.03.2024.
//

import Foundation

class ApiService {

    private var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist["APIKey"] as? String else {
            fatalError("Couldn't find key 'APIKey' in 'Config.plist'")
        }
        return value
    }

    func createPixabayURL(with request: String) -> URL {
        guard let url = URL(string: "https://pixabay.com/api/?key=\(apiKey)&q=\(request)") else {
            fatalError("Invalid URL")
        }
        return url
    }
}
