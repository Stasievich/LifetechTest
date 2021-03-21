//
//  ProductsCollectionViewCell.swift
//  LifetechTest
//
//  Created by Victor on 3/21/21.
//

import Foundation
import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {
    let indent: CGFloat = 2
    
    var cellStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 5
        sv.distribution = .equalSpacing
        return sv
    }()
    
    var productImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        return img
    }()
    
    var productName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var productPrice: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        lbl.textColor = .gray
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cellStackView)
        
        cellStackView.addArrangedSubview(productImage)
        cellStackView.addArrangedSubview(productName)
        cellStackView.addArrangedSubview(productPrice)
        
        contentView.addConstraints([
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: indent),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -indent),
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: indent),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -indent)
        ])
        
        cellStackView.addConstraints([
            productImage.heightAnchor.constraint(equalTo: cellStackView.heightAnchor, multiplier: 0.6),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

