import Foundation
import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import CoreImage

class MetropolitanDetailController:UIViewController,Coordinating {
    var coordinator: Coordinator?
    var viewModel:ArtObjectViewModel?
    private let disposeBag = DisposeBag()
    private let intensitySlider = UISlider()
    private let radiusSlider = UISlider()
    private var imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    private func setupUI() {
        view.backgroundColor = .white
        let intensityLabel = UILabel()
        let radiusLabel = UILabel()
        intensityLabel.text = "強度"
        intensityLabel.font = .systemFont(ofSize: 18)
        intensityLabel.textColor = .darkGray
        radiusLabel.text = "丸み"
        radiusLabel.font = .systemFont(ofSize: 18)
        radiusLabel.textColor = .darkGray
        view.addSubview(imageView)
        let stack = UIStackView(arrangedSubviews: [intensityLabel,intensitySlider,radiusLabel,radiusSlider])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: CGFloat(view.frame.width)).isActive = true
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 30).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30).isActive = true
        intensitySlider.addTarget(self, action: #selector(intensityChanged), for: .valueChanged)
        radiusSlider.addTarget(self, action: #selector(radiusChanged), for: .valueChanged)
    }
    private func setupBinding() {
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
    @objc private func intensityChanged() {
        print(#function)
    }
    @objc private func radiusChanged() {
        print(#function)
    }
}
