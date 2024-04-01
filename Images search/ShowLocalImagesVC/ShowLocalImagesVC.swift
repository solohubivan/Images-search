//
//  ShowLocalImagesVC.swift
//  Images search
//
//  Created by Ivan Solohub on 28.03.2024.
//

import UIKit
import Photos
import TOCropViewController

class ShowLocalImagesVC: UIViewController {

    @IBOutlet weak private var goBackButton: UIButton!
    @IBOutlet weak private var showEditedImagesButton: UIButton!
    @IBOutlet weak private var imageView: UIView!
    @IBOutlet weak private var mainImageView: UIImageView!
    @IBOutlet weak private var zoomImageButton: UIButton!
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
    
    override func viewDidLayoutSubviews() {
        editImageButton.titleLabel?.font = UIFont(name: AppConstants.Fonts.openSansRegular, size: 14)
        showEditedImagesButton.titleLabel?.font = UIFont(name: AppConstants.Fonts.openSansMedium, size: 16)
        showEditedImagesButton.titleLabel?.textAlignment = .center
        showEditedImagesButton.titleLabel?.numberOfLines = 1
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
}

// MARK: - TOCropViewController properties

extension ShowLocalImagesVC: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        EditedImagesDataManager.shared.saveEditedImage(image)
    }
}

// MARK: - CollectionView properties

extension ShowLocalImagesVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = otherLocalImagesCollectionView.dequeueReusableCell(withReuseIdentifier: "LocalImagePreviewCellId", for: indexPath) as! LocalImagesCollectionViewCellsCreator
        
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

// MARK: - Button Actions

extension ShowLocalImagesVC {
    
    @IBAction private func showEditedImagesVC(_ sender: Any) {
        let vc = EditedImagesVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    @IBAction private func editingImage(_ sender: Any) {
        guard let image = mainImageView.image else { return }
        let vc = TOCropViewController(croppingStyle: .default, image: image)
        vc.toolbarPosition = .bottom
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction private func shareImage(_ sender: Any) {
        guard let image = mainImageView.image else { return }
        let shareUtility = ShareUtility()
        let shareViewController = shareUtility.createShareViewController(imageToShare: image, sourceView: shareButton)
        present(shareViewController, animated: true, completion: nil)
    }
    
    @IBAction private func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction private func zoomImage(_ sender: Any) {
        if let image = mainImageView.image {
            let zoomedViewController = ZoomedImageViewController(zoomableImage: image)
            zoomedViewController.modalPresentationStyle = .fullScreen
            present(zoomedViewController, animated: false)
        }
    }
}

// MARK: - Setup UI

extension ShowLocalImagesVC {

    private func setupUI() {
        setupGoBackButton()
        setupShowEditedImagesButton()
        setupEditImageButton()
        setupShareButton()
        setupLocalImagesCollectionView()
        setupZoomImageButton()
    }
    
    private func setupGoBackButton() {
        goBackButton.setTitle("", for: .normal)
    }
    
    private func setupShowEditedImagesButton() {
        showEditedImagesButton.setTitle("Edited images", for: .normal)
        showEditedImagesButton.setTitleColor(UIColor.hex430BE0, for: .normal)
        showEditedImagesButton.layer.borderWidth = 2
        showEditedImagesButton.layer.borderColor = UIColor.hex430BE0.cgColor
        showEditedImagesButton.layer.cornerRadius = 5
        showEditedImagesButton.titleLabel?.numberOfLines = 1
    }
    
    private func setupEditImageButton() {
        editImageButton.setTitle("Edit image", for: .normal)
        editImageButton.backgroundColor = .white
        editImageButton.setTitleColor(UIColor.hex2D2D2D, for: .normal)
        editImageButton.setTitleColor(UIColor.hex2D2D2D, for: .highlighted)
        editImageButton.layer.borderWidth = 1
        editImageButton.layer.cornerRadius = 3
        editImageButton.layer.borderColor = UIColor.hex430BE0.cgColor
        editImageButton.titleLabel?.numberOfLines = 1
    }
    
    private func setupShareButton() {
        shareButton.setTitle("", for: .normal)
    }
    
    private func setupZoomImageButton() {
        zoomImageButton.setTitle("", for: .normal)
    }
    
    private func setupLocalImagesCollectionView() {
        otherLocalImagesCollectionView.dataSource = self
        otherLocalImagesCollectionView.delegate = self
        otherLocalImagesCollectionView.register(LocalImagesCollectionViewCellsCreator.self, forCellWithReuseIdentifier: "LocalImagePreviewCellId")
        otherLocalImagesCollectionView.overrideUserInterfaceStyle = .light
    }
}
