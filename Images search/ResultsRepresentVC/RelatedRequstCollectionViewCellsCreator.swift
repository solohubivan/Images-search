//
//  RelatedRequstCollectionViewCellsCreator.swift
//  Images search
//
//  Created by Ivan Solohub on 06.03.2024.
//

import UIKit

class RelatedRequstCollectionViewCellsCreator: UICollectionViewCell {
    
    var mainLabel = UILabel()
    var relatedTags: UILabel = {
        let label = UILabel()
        label.text = "Ivan"
        label.textColor = .orange
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(relatedTags)
        setupLabel()
    }
    
    private func setupLabel() {
        relatedTags.addConstraints(to_view: self)
    }
}
