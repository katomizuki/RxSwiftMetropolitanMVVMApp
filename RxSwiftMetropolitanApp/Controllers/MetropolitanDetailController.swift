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
    private let scaleSlider = UISlider()
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
        currentImage = imageView.image
        applyProcessing()
    }
    private func setupUI() {
        view.backgroundColor = .white
        let intensityLabel = UILabel()
        let radiusLabel = UILabel()
        let scaleLabel = UILabel()
        intensityLabel.text = "強度"
        intensityLabel.font = .systemFont(ofSize: 18)
        intensityLabel.textColor = .darkGray
        radiusLabel.text = "丸み"
        radiusLabel.font = .systemFont(ofSize: 18)
        radiusLabel.textColor = .darkGray
        scaleLabel.textColor = .darkGray
        scaleLabel.text = "拡大度"
        scaleLabel.font = .systemFont(ofSize: 18)
        view.addSubview(imageView)
        let stack = UIStackView(arrangedSubviews: [intensityLabel,intensitySlider,radiusLabel,radiusSlider,scaleLabel,scaleSlider])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 5
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
        buttonStack.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20).isActive = true
        buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
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
       applyProcessing()
    }
    @objc private func radiusChanged() {
        print(#function)
        applyProcessing()
    }
    @objc private func didTapSaveButton() {
        print(#function)
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(didFinishSave), nil)
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
           ac.addAction(UIAlertAction(title: "CIColorInvert", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIColorMonochrome", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true, completion: nil)
        
    }
    private func setFilter(_ action:UIAlertAction) {
         guard currentImage != nil else { return }

           // safely read the alert action's title
           guard let actionTitle = action.title else { return }

           currentFilter = CIFilter(name: actionTitle)

           let beginImage = CIImage(image: currentImage!)
           currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            
           applyProcessing()
        
    }
    private func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage!.size.width, y: currentImage!.size.height), forKey: kCIInputCenterKey) }
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey) }
          if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(radiusSlider.value * 200, forKey: kCIInputRadiusKey) }
          if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(scaleSlider.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputColorKey) {
            currentFilter.setValue(CIColor(red: 0.5, green: 0.5, blue: 0.5), forKey: kCIInputColorKey)
        }
        guard let image = currentFilter.outputImage else { return }
           if let cgimg = context.createCGImage(image, from: image.extent) {
               let processedImage = UIImage(cgImage: cgimg)
               imageView.image = processedImage
           }
    }
    @objc private func didFinishSave(_ image:UIImage,didFinishSavingWithError error: Error?,contextInfo: UnsafeRawPointer) {
        print(#function)
        if let error = error {
            print(error.localizedDescription)
            let ac = UIAlertController(title: "保存失敗", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "保存成功", message: "無事、あなたのライブラリに保存されました", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        
    }
 
}
