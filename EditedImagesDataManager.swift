//
//  EditedImagesDataManager.swift
//  Images search
//
//  Created by Ivan Solohub on 31.03.2024.
//

import Foundation
import UIKit

class EditedImagesDataManager {
    
    static let shared = EditedImagesDataManager()
    
    private var editedImages: [UIImage] = []
    
    private init() {
        loadEditedImages()
    }
    
    // MARK: - Public methods
    
    func saveEditedImage(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        let uniqueID = UUID().uuidString
        let filename = getDocumentsDirectory().appendingPathComponent("\(uniqueID).jpeg")
        try? data.write(to: filename)
        
        editedImages.append(image)
    }
    
    func getEditedImages() -> [UIImage] {
        return editedImages
    }
    
    func getEditedImagesCount() -> Int {
        return editedImages.count
    }
    
    // MARK: - Private methods
    
    private func loadEditedImages() {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        guard let fileURLs = try? fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) else { return }
            
        for fileURL in fileURLs where fileURL.pathExtension == "jpeg" {
            if let image = UIImage(contentsOfFile: fileURL.path) {
                editedImages.append(image)
            }
        }
    }
        
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
