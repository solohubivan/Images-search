//
//  ShowResultsCollectionViewCellsCreator.swift
//  Images search
//
//  Created by Ivan Solohub on 05.03.2024.
//

import UIKit
import SDWebImage

class ShowResultsCollectionViewCellsCreator: UICollectionViewCell {
    
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
    
    // MARK: - Public method to set image

    func setImage(with url: URL) {
        previewImageView.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground,.progressiveLoad], completed: nil)
    }
}

