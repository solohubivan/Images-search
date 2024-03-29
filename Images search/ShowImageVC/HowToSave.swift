//
//  HowToSave.swift
//  Images search
//
//  Created by Ivan Solohub on 28.03.2024.
//

/*
 
 func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
     let status = PHPhotoLibrary.authorizationStatus()
     switch status {
     case .authorized:

         completion(true)
     case .notDetermined:
         PHPhotoLibrary.requestAuthorization { newStatus in
             if newStatus == .authorized {
                 completion(true)
             } else {
                 completion(false)
             }
         }
     default:
         completion(false)
     }
 }

 func createAlbumIfNeeded(albumName: String, completion: @escaping (PHAssetCollection?) -> Void) {
     let fetchOptions = PHFetchOptions()
     fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
     let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

     if let album = collection.firstObject {
         completion(album)
     } else {
         var albumPlaceholder: PHObjectPlaceholder?
         PHPhotoLibrary.shared().performChanges({
             let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
             albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
         }) { success, error in
             if success, let placeholder = albumPlaceholder {
                 let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                 let album = fetchResult.firstObject
                 completion(album)
             } else {
                 print("Error album creating: \(error?.localizedDescription ?? "неизвестно")")
                 completion(nil)
             }
         }
     }
 }

 func saveImageToAlbum(image: UIImage, albumName: String) {
     checkPhotoLibraryPermission { accessGranted in
         guard accessGranted else {
//          тут маэ буть алєрт, що доступ до альбома закритий
             return
         }
         
         self.createAlbumIfNeeded(albumName: albumName) { album in
             guard let album = album else { return }
             PHPhotoLibrary.shared().performChanges({
                 let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                 let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
                 guard let assetPlaceholder = assetPlaceholder else { return }
                 if let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) {
                     let enumeration: NSArray = [assetPlaceholder]
                     albumChangeRequest.addAssets(enumeration)
                 }
             }) { success, error in
                 if success {
                     //тут алєрт, що зображення успішно збережене
//                        print("Изображение успешно сохранено в альбом '\(albumName)'.")
                 } else {
                     //тут алєрт, що помилка збереження
//                        print("Ошибка сохранения изображения: \(error?.localizedDescription ?? "неизвестно")")
                 }
             }
         }
     }
 }
 
 
 
 func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     picker.dismiss(animated: true)
 }
 
 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     guard let image = info[.originalImage] as? UIImage else { return }
     picker.dismiss(animated: true)
     showCrop(image: image)
 }
 
 private func showCrop(image: UIImage) {
     let vc = TOCropViewController(croppingStyle: .default, image: image)
     vc.toolbarPosition = .bottom
     vc.delegate = self
     present(vc, animated: true)
 }
 
 func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
     cropViewController.dismiss(animated: true)
 }
 
 func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
     cropViewController.dismiss(animated: true, completion: nil)
     saveImageToAlbum(image: image, albumName: "Edited")
 }
 
 @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
     if let error = error {
         print("Ошибка сохранения изображения: \(error.localizedDescription)")
     } else {
         print("Изображение успешно сохранено в фотоальбом")
     }
 }
 
 */
