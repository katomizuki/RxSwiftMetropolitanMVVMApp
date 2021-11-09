import Foundation
import RxSwift
import RxCocoa
// MARK: - ArtObjectViewModel
struct ArtObjectViewModel {
    let art:ArtObject
    var title:Observable<String> {
        return Observable<String>.just(art.title)
    }
    var primaryImage:Observable<String> {
        return Observable<String>.just(art.primaryImage)
    }
    var displayName:Observable<String> {
        return Observable<String>.just(art.artistDisplayName)
    }
    init(art:ArtObject) {
        self.art = art
    }
}
// MARK: - ArtListObjectViewModel
struct ArtListObjectViewModel {
    let artObjVM:[ArtObjectViewModel]
}
extension ArtListObjectViewModel {
    
    init(_ arts:[ArtObject]) {
        self.artObjVM = arts.compactMap(ArtObjectViewModel.init)
    }
    func articleAt(_ index: Int) -> ArtObjectViewModel {
        return self.artObjVM[index]
    }
}

struct Resource <T: Decodable> {
    let url:URL
}
