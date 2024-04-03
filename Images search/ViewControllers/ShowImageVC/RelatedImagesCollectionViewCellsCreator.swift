//
//  CollectionViewCell.swift
//  Images search
//
//  Created by Ivan Solohub on 13.03.2024.
//

import UIKit

class RelatedImagesCollectionViewCellsCreator: UICollectionViewCell {
    
    private var previewImageView: UIImageView = {
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
        addSubview(previewImageView)
        setupImageView()
    }
    
    private func setupImageView() {
        previewImageView.addConstraints(to_view: self)
    }
    
    func setImage(with url: URL) {
        previewImageView.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground,.progressiveLoad])
    }
}
