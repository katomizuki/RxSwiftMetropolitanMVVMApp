import Foundation
import Alamofire
import RxSwift
import RxCocoa
struct ArtObjectDataModel {
    static func fetchArtObject(completion: @escaping(Observable<[ArtObject]>) -> Void) {
        var arts = [ArtObject]()
        let dispatchGroup = DispatchGroup()
        for i in 60121...60221 {
            dispatchGroup.enter()
        let metropolitanUrl = "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(i)"
        AF.request(metropolitanUrl).responseJSON { response in
            switch response.result {
            case .success:
                guard let responseData = response.data else { return }
                do {
                    defer { dispatchGroup.leave() }
                let artData = try JSONDecoder().decode(ArtObject.self, from: responseData)
                    print(artData)
                    arts.append(artData)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
      }
        dispatchGroup.notify(queue: .main) {
            arts = arts.filter{ $0.primaryImage != "" }
            completion(Observable.just(arts))
        }
    }
    
    static func load<T>(resource: Resource<T>) -> Observable<T> {
        return Observable.just(resource.url)
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
        }
        
    }
}
