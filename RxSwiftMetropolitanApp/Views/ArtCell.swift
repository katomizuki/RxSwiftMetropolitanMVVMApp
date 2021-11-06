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
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
