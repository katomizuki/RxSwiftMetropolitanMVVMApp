//
//  MetropolitanDetailController.swift
//  RxSwiftMetropolitanApp
//
//  Created by ミズキ on 2021/11/09.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SDWebImage
class MetropolitanDetailController:UIViewController,Coordinating {
    var coordinator: Coordinator?
    var viewModel:ArtObjectViewModel?
    private let disposeBag = DisposeBag()
    private var imageView = UIImageView()
    private var displayLabel = UILabel()
    private var titleLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        displayLabel.numberOfLines = 0
        titleLabel.numberOfLines = 0
        displayLabel.sizeToFit()
        titleLabel.sizeToFit()
        view.addSubview(imageView)
        view.addSubview(displayLabel)
        view.addSubview(titleLabel)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 30).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        displayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        displayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        displayLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        setupUI()
    }
    private func setupUI() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.primaryImage.asDriver(onErrorJustReturn: "")
            .drive { [weak self] urlStriing in
                let url = URL(string: urlStriing)
                self?.imageView.sd_setImage(with: url, completed: nil)
            }
            .disposed(by: disposeBag)
    }
}
