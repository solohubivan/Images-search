//
//  PixabayDataManager.swift
//  Images search
//
//  Created by Ivan Solohub on 05.03.2024.
//

import Foundation

class PixabayDataManager {
    
//    static let shared = PixabayDataManager()
    
    private var pixabayData = PixabayData()
    private let apiService = ApiService()
    
    func createSearchRequest(userRequest: String, _ imageTypeCategory: String, page: Int?) -> String {
        let inputTypeCategory = imageTypeCategory.lowercased()
        let resultRequest = "\(userRequest)&image_type=\(inputTypeCategory)&page=\(page ?? 1)"
        return resultRequest
    }
    
    func getImageViewModelData() -> [ImageViewModelData] {
        var imageUrls: [ImageViewModelData] = []
        for hit in pixabayData.hits {
            let imageUrlsData = ImageViewModelData(
                previewImageUrl: hit.webformatURL,
                fullsizeImageUrl: hit.largeImageURL,
                likes: hit.likes ?? 0,
                comments: hit.comments ?? 0,
                downloads: hit.downloads ?? 0,
                views: hit.views ?? 0
            )
            imageUrls.append(imageUrlsData)
        }
        return imageUrls
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

    func getPixabayData(request: String, completion: @escaping (PixabayData) -> Void) {
        let session = URLSession.shared
        let url = apiService.createPixabayURL(with: request)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else { return }
            
            do {
                self.pixabayData = try JSONDecoder().decode(PixabayData.self, from: data)
                completion(self.pixabayData)

            } catch {
                
            }
        }
        task.resume()
    }
    /*
    func getPixabayData(request: String, completion: @escaping (Result<PixabayData, Error>) -> Void) {
        let session = URLSession.shared
        let url = apiService.createPixabayURL(with: request)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data is nil"])))
                return
            }
            
            do {
                let pixabayData = try JSONDecoder().decode(PixabayData.self, from: data)
                completion(.success(pixabayData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
 */
}
