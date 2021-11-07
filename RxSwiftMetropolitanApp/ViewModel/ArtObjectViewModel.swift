import Foundation
import RxSwift
import RxCocoa
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
