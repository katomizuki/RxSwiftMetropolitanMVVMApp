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
    private var currentImage:UIImage?
    private var context:CIContext!
    private var currentFilter:CIFilter!
    private lazy var changeButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("チェンジ", for: .normal)
        button.addTarget(self, action: #selector(didTapChangeButton), for: .touchUpInside)
        return button
    }()
    private lazy var saveButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("保存", for: .normal)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        guard let image = imageView.image else { return }
        let beginImage = CIImage(image: image)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
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
        let buttonStack = UIStackView(arrangedSubviews: [changeButton,saveButton])
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.spacing = 30
        buttonStack.distribution = .fillEqually
        saveButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(buttonStack)
        buttonStack.topAnchor.constraint(equalTo: radiusSlider.bottomAnchor, constant: 20).isActive = true
        buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 30).isActive = true
        buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
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
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey)
        }
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    @objc private func radiusChanged() {
        print(#function)
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(radiusSlider.value, forKey: kCIInputRadiusKey)
        }
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    @objc private func didTapSaveButton() {
        print(#function)
    }
    @objc private func didTapChangeButton(sender: UIButton) {
        print(#function)
        let ac = UIAlertController(title: "フィルター選択", message: nil, preferredStyle: .actionSheet)
           ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true, completion: nil)
        
    }
    private func setFilter(_ action:UIAlertAction) {
        print(#function)
    }
}
