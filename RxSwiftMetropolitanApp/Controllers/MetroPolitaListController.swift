import UIKit
import RxSwift

final class MetroPolitaListController: UIViewController {
    private lazy var collectionView:UICollectionView = {
        let layout = MetroPolitaListController.createCompositionalLayout()
        let frame = view.frame
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(ArtCell.self, forCellWithReuseIdentifier: ArtCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }
}

extension MetroPolitaListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}
extension MetroPolitaListController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtCell.id, for: indexPath) as? ArtCell else { fatalError() }
        return cell
    }
}

// MARK: compostionLayout
extension MetroPolitaListController {
    static func createCompositionalLayout()->UICollectionViewCompositionalLayout {
        //Item
        let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemsize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                     leading: 2,
                                                     bottom: 2,
                                                     trailing: 2)
        
        let verticalStackItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                           heightDimension:.fractionalHeight(0.5))
        let verticalStackItem = NSCollectionLayoutItem(layoutSize: verticalStackItemSize)
        verticalStackItem.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                                  leading: 2,
                                                                  bottom: 2,
                                                                  trailing: 2)
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                       heightDimension: .fractionalHeight(1))
        let verticalStackGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize,
                                                                  subitem: verticalStackItem,
                                                                  count: 2)
        let tripleItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .fractionalHeight(1))
        let tripleItem = NSCollectionLayoutItem(layoutSize: tripleItemSize)
        tripleItem.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                           leading: 2,
                                                           bottom: 2,
                                                           trailing: 2)
        let tripleHorizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                               heightDimension: .fractionalHeight(0.2))
        let tripleHorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: tripleHorizontalGroupSize,
                                                                       subitem: tripleItem,
                                                                       count: 3)
        //Group
        let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension:.fractionalHeight(0.4))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize,
                                                       subitems: [item,
                                                                  verticalStackGroup])
        let leftHorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize,
                                                                     subitems: [verticalStackGroup,
                                                                                item])
        let verticalSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalSize,
                                                             subitems: [horizontalGroup,
                                                                        tripleHorizontalGroup,
                                                                        leftHorizontalGroup])
        
        
        //Sections
        let section = NSCollectionLayoutSection(group: verticalGroup)
        return UICollectionViewCompositionalLayout(section: section)
        //Return
    }
}

