//
//  ShowLocalImagesVC.swift
//  Images search
//
//  Created by Ivan Solohub on 28.03.2024.
//

import UIKit
import Photos

class ShowLocalImagesVC: UIViewController {

    @IBOutlet weak private var goBackButton: UIButton!
    @IBOutlet weak private var imageView: UIView!
    @IBOutlet weak private var mainImageView: UIImageView!
    @IBOutlet weak private var editImageButton: UIButton!
    @IBOutlet weak private var shareButton: UIButton!
    @IBOutlet weak private var otherLocalImagesCollectionView: UICollectionView!
    
    var selectedLocalImage: UIImage?
    
    private var imageAssets = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexF6F6F6
        checkPhotoLibraryPermission()
        setupUI()
        mainImageView.image = selectedLocalImage
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        setupGoBackButton()
        setupShareButton()
        setupLocalImagesCollectionView()
    }
    
    private func setupGoBackButton() {
        goBackButton.setTitle("", for: .normal)
    }
    
    private func setupShareButton() {
        shareButton.setTitle("", for: .normal)
    }
    
    private func setupLocalImagesCollectionView() {
        otherLocalImagesCollectionView.dataSource = self
        otherLocalImagesCollectionView.delegate = self
        otherLocalImagesCollectionView.register(LocalImagesCollectionViewCellsCreator.self, forCellWithReuseIdentifier: "localImagePreview")
        otherLocalImagesCollectionView.overrideUserInterfaceStyle = .light
    }
    
    // MARK: - Private methods

    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            loadPhotosFromLibrary()
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.loadPhotosFromLibrary()
                    }
                }
            }
        }
    }
        
    private func loadPhotosFromLibrary() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        assets.enumerateObjects { (object, _, _) in
            self.imageAssets.append(object)
        }
        DispatchQueue.main.async {
            self.otherLocalImagesCollectionView.reloadData()
        }
    }
    
    // MARK: - Button Actions

    @IBAction private func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

// MARK: - CollectionView properties

extension ShowLocalImagesVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = otherLocalImagesCollectionView.dequeueReusableCell(withReuseIdentifier: "localImagePreview", for: indexPath) as! LocalImagesCollectionViewCellsCreator
        
        let asset = imageAssets[indexPath.item]
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.previewImageView.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let asset = imageAssets[indexPath.item]

            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = false
            options.isNetworkAccessAllowed = true
            
            PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { [weak self] image, _ in
                DispatchQueue.main.async {
                    self?.mainImageView.image = image
                }
            }
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width) / 2
        let height = width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
