//
//  EditedImagesVC.swift
//  Images search
//
//  Created by Ivan Solohub on 29.03.2024.
//

import UIKit
import TOCropViewController

class EditedImagesVC: UIViewController {
    
    @IBOutlet weak private var goBackButton: UIButton!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var editedImagesCollectionView: UICollectionView!
    @IBOutlet weak private var noImagesAlertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexF6F6F6
        setupUI()
        checkAvailableEditedImages()
    }
    
    // MARK: - Orientation Lock

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: - Private methods
    
    private func checkAvailableEditedImages() {
        let editedImages = EditedImagesDataManager.shared.getEditedImages()
        let hasEditedImages = !editedImages.isEmpty
        editedImagesCollectionView.isHidden = !hasEditedImages
        noImagesAlertLabel.isHidden = hasEditedImages
    }
    
    // MARK: - Buttons actions
    
    @IBAction private func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// MARK: - UICollectionView properties

extension EditedImagesVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EditedImagesDataManager.shared.getEditedImagesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = editedImagesCollectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.CollectionViewCellsId.editedImagesCellID, for: indexPath) as! EditedImagesVCCollectionViewCell
        
        let editedImage = EditedImagesDataManager.shared.getEditedImages()[indexPath.row]
        cell.editedImageView.image = editedImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width) / 3
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = EditedImagesDataManager.shared.getEditedImages()[indexPath.row]
        let zoomedViewController = ZoomedImageViewController(zoomableImage: selectedImage)
        zoomedViewController.modalPresentationStyle = .fullScreen
        present(zoomedViewController, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let shareAction = UIAction(title: AppConstants.EditedImagesVC.actionTitleShare, image: UIImage(systemName: AppConstants.ImageNames.squareAndArrow)) { action in
                let selectedImage = EditedImagesDataManager.shared.getEditedImages()[indexPath.row]
                let shareUtility = ShareUtility()
                let shareViewController = shareUtility.createShareViewController(imageToShare: selectedImage, sourceView: self.editedImagesCollectionView)
                self.present(shareViewController, animated: true, completion: nil)
            }

            let editAction = UIAction(title: AppConstants.EditedImagesVC.actionTitleEditImage, image: UIImage(systemName: AppConstants.ImageNames.cropRotate)) { action in
                let selectedImage = EditedImagesDataManager.shared.getEditedImages()[indexPath.row]
                let vc = TOCropViewController(croppingStyle: .default, image: selectedImage)
                vc.toolbarPosition = .bottom
                vc.delegate = self
                self.present(vc, animated: true)
            }
            
            let deleteAction = UIAction(title: AppConstants.EditedImagesVC.actionTitleDelete, image: UIImage(systemName: AppConstants.ImageNames.trash), attributes: .destructive) { action in
                EditedImagesDataManager.shared.deleteEditedImage(at: indexPath.row)
                self.editedImagesCollectionView.deleteItems(at: [indexPath])
                self.checkAvailableEditedImages()
            }
            
            return UIMenu(title: "", children: [shareAction, editAction, deleteAction])
        }
    }
}

// MARK: - TOCropViewController properties

extension EditedImagesVC: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        EditedImagesDataManager.shared.saveEditedImage(image)
        checkAvailableEditedImages()
        editedImagesCollectionView.reloadData()
    }
}

// MARK: - Setup UI

extension EditedImagesVC {
    
    private func setupUI() {
        setupTitleLabel()
        setupEditedImagesCollView()
        setupGoBackButton()
        setupNoImagesAlertLabel()
    }
    
    private func setupGoBackButton() {
        goBackButton.setTitle("", for: .normal)
    }
    
    private func setupTitleLabel() {
        titleLabel.text = AppConstants.EditedImagesVC.titleLabelEditedImages
        titleLabel.textColor = UIColor.hex430BE0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: AppConstants.Fonts.openSansSemibold, size: 25)
    }
    
    private func setupEditedImagesCollView() {
        editedImagesCollectionView.delegate = self
        editedImagesCollectionView.dataSource = self
        editedImagesCollectionView.overrideUserInterfaceStyle = .light
        editedImagesCollectionView.backgroundColor = .clear
        editedImagesCollectionView.register(EditedImagesVCCollectionViewCell.self, forCellWithReuseIdentifier: AppConstants.CollectionViewCellsId.editedImagesCellID)
    }
    
    private func setupNoImagesAlertLabel() {
        noImagesAlertLabel.text = AppConstants.EditedImagesVC.noImagesAlertLabel
        noImagesAlertLabel.font = UIFont(name: AppConstants.Fonts.openSansBold, size: 25)
        noImagesAlertLabel.textColor = .lightGray
    }
}
