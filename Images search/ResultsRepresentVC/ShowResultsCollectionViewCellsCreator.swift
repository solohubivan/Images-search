//
//  ShowResultsCollectionViewCellsCreator.swift
//  Images search
//
//  Created by Ivan Solohub on 05.03.2024.
//

import UIKit
import SDWebImage

class ShowResultsCollectionViewCellsCreator: UICollectionViewCell {
    
    weak var parentViewController: ResultsRepresentVC?
    
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
        shareButton.setImage(UIImage(named: AppConstants.ImageNames.share), for: .normal)
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
        
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    private func setupImageView() {
        previewImageView.addConstraints(to_view: self)
    }
    
    // MARK: - Public method to set image

    func setImage(with url: URL) {
        previewImageView.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground,.progressiveLoad]) { [weak self] (image, error, cacheType, imageUrl) in
            guard let self = self else { return }
            if error == nil {
                self.setupShareButton()
            }
        }
    }
    
    // MARK: - Share Button action
    
    @objc private func shareButtonTapped() {
        guard let imageToShare = previewImageView.image else { return }
            
        let shareViewController = ShareUtility.createShareViewController(imageToShare: imageToShare, sourceView: self)
        shareViewController.popoverPresentationController?.sourceRect = shareButton.frame
        shareViewController.popoverPresentationController?.sourceView = self
        shareViewController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
            
        if let parentViewController = parentViewController {
            parentViewController.present(shareViewController, animated: true, completion: nil)
        }
    }
}

