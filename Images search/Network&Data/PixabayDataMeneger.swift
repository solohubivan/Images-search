//
//  PixabayDataMeneger.swift
//  Images search
//
//  Created by Ivan Solohub on 05.03.2024.
//

import Foundation

class PixabayDataMeneger {
    
    static let shared = PixabayDataMeneger()
    
    private var pixabayData = PixabayData()
    
    
    func createSearchRequest(userRequest: String, _ imageTypeCategory: String) -> String {
        let resultRequest = "\(userRequest)&image_type=\(imageTypeCategory)"
        return resultRequest
    }
    
    func getLinksToPreviewImages() -> [String] {
        var array: [String] = []
        array = pixabayData.hits.map { $0.webformatURL }
        return array
    }
    
    func creatingRelatedStrings() -> [String] {
        var resultArray: [String] = []
        var array: [String] = []
        array = pixabayData.hits.map { $0.tags }
        let combinedString = array.joined(separator: ", ")
        let words = combinedString.components(separatedBy: ", ")
        let uniqueWords = Array(Set(words))
        resultArray = uniqueWords
        return resultArray
    }

    func getFoundImagesCount() -> Int {
        return pixabayData.hits.count
    }

    func getPixabayData(request: String, completion: @escaping (PixabayData) -> Void) {
        let session = URLSession.shared
        let url = URL(string: "https://pixabay.com/api/?key=42641694-e1b511cb1c14ec9fc839ed366&q=\(request)")!
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                print(error!.localizedDescription)
                return
            }
            
            do {
                self.pixabayData = try JSONDecoder().decode(PixabayData.self, from: data)
                completion(self.pixabayData)

            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
