//
//  ArtCell.swift
//  RxSwiftMetropolitanApp
//
//  Created by ミズキ on 2021/11/06.
//

import Foundation
import UIKit

class ArtCell: UICollectionViewCell {
    static let id = "ArtCell"
    var imageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
