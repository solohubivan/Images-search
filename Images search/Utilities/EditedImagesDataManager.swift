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
    private let fileManager = FileManager.default
    private var editedImages: [UIImage] = []
    
    private init() {
        loadEditedImages()
    }
    
    // MARK: - Public methods
    
    func deleteEditedImage(at index: Int) {
        guard index < editedImages.count else { return }
        
        let documentsURL = getDocumentsDirectory()
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            editedImages.remove(at: index)
                
            if index < fileURLs.count {
                let fileURL = fileURLs[index]
                try fileManager.removeItem(at: fileURL)
            }
        } catch {

        }
    }
    
    func saveEditedImage(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        let uniqueID = UUID().uuidString
        let filename = getDocumentsDirectory().appendingPathComponent("\(uniqueID).jpeg")
        
        do {
            try data.write(to: filename)
            editedImages.append(image)
        } catch {

        }
    }
    
    func getEditedImages() -> [UIImage] {
        return editedImages
    }
    
    func getEditedImagesCount() -> Int {
        return editedImages.count
    }
    
    // MARK: - Private methods
    
    private func loadEditedImages() {
        let documentsURL = getDocumentsDirectory()
        do {

            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for fileURL in fileURLs where fileURL.pathExtension == AppConstants.EditedImagesDataManager.imageFileExtension {
                if let image = UIImage(contentsOfFile: fileURL.path) {
                    editedImages.append(image)
                }
            }
        } catch {

        }
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? URL(fileURLWithPath: "/")
    }
}
