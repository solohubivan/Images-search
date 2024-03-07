//
//  RelatedRequstCollectionViewCellsCreator.swift
//  Images search
//
//  Created by Ivan Solohub on 06.03.2024.
//

import UIKit

class RelatedRequstCollectionViewCellsCreator: UICollectionViewCell {
    
    var relatedTags = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelSize = relatedTags.sizeThatFits(CGSize(width: size.width, height: .greatestFiniteMagnitude))
        return CGSize(width: size.width, height: labelSize.height)
    }
    
    // MARK: - Setup UI
    
    private func setupSubviews() {
        setupRelatedTagsLabels()
    }

    private func setupRelatedTagsLabels() {
        let labelContainer = UIView()
        labelContainer.layer.borderWidth = 1
        labelContainer.layer.borderColor = UIColor.hexD2D2D2.cgColor
        labelContainer.layer.cornerRadius = 3
        labelContainer.layer.backgroundColor = UIColor.hexE2E2E2.cgColor
        
        labelContainer.addSubview(relatedTags)
        relatedTags.addConstraints(to_view: labelContainer, [
            .leading(anchor: labelContainer.leadingAnchor, constant: 10),
            .trailing(anchor: labelContainer.trailingAnchor, constant: 10)
            ])
        
        relatedTags.text = ""
        relatedTags.textColor = .black
        relatedTags.font = UIFont(name: "OpenSans-Regular", size: 14)

        addSubview(labelContainer)
        labelContainer.addConstraints(to_view: self)
    }
}
