//
//  EditedImagesVCCollectionViewCell.swift
//  Images search
//
//  Created by Ivan Solohub on 29.03.2024.
//

import UIKit

class EditedImagesVCCollectionViewCell: UICollectionViewCell {
    
    var editedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupSubviews() {
        addSubview(editedImageView)
        setupImageView()
    }
    
    private func setupImageView() {
        editedImageView.addConstraints(to_view: self)
    }
}
