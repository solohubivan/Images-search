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
    
    private var shareButton = UIButton()

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
    
    private func setupShareButton() {
        shareButton.titleLabel?.text = ""
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.layer.borderWidth = 1
        shareButton.layer.borderColor = UIColor.clear.cgColor
        shareButton.layer.cornerRadius = 3
        
        addSubview(shareButton)
        shareButton.addConstraints(to_view: self, [
            .top(anchor: self.topAnchor, constant: 16),
            .trailing(anchor: self.trailingAnchor, constant: 16),
            .width(constant: 40),
            .height(constant: 40)
        ])
    }
    
    private func setupImageView() {
        previewImageView.addConstraints(to_view: self)
    }
    
    // MARK: - Public method to set image
//уточни в іі що означають оті вінзєля в гарді
    func setImage(with url: URL) {
        previewImageView.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground,.progressiveLoad]) { [weak self] (image, error, cacheType, imageUrl) in
            guard let self = self else { return }
            if error == nil {
                self.setupShareButton()
            }
        }
    }
}

