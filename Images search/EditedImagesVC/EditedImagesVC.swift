//
//  EditedImagesVC.swift
//  Images search
//
//  Created by Ivan Solohub on 29.03.2024.
//

import UIKit

class EditedImagesVC: UIViewController {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var editedImagesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexF6F6F6
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        titleLabel.font = UIFont(name: AppConstants.Fonts.openSansMedium, size: 16)
    }
    
    // MARK: - Setup UI

    private func setupUI() {
        setupTitleLabel()
        setupEditedImagesCollView()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Edited images"
        titleLabel.textColor = UIColor.hex2D2D2D
        titleLabel.textAlignment = .center
    }
    
    private func setupEditedImagesCollView() {
        editedImagesCollectionView.delegate = self
        editedImagesCollectionView.dataSource = self
        editedImagesCollectionView.overrideUserInterfaceStyle = .light
        editedImagesCollectionView.backgroundColor = .clear
        editedImagesCollectionView.register(EditedImagesVCCollectionViewCell.self, forCellWithReuseIdentifier: "EditedImagesCellID")
    }

}

// MARK: - UICollectionView properties

extension EditedImagesVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EditedImagesDataManager.shared.getEditedImagesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = editedImagesCollectionView.dequeueReusableCell(withReuseIdentifier: "EditedImagesCellID", for: indexPath) as! EditedImagesVCCollectionViewCell
        
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
}
