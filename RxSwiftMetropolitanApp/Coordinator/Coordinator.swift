import Foundation
import UIKit
enum Event {
    case pushNav
}
protocol Coordinator {
    func start()
    var navigationController: UINavigationController? { get set }
    func eventOccured(with type: Event,viewModel:ArtObjectViewModel)
}
protocol Coordinating {
    var coordinator:Coordinator? { get set }
}
struct MainCoordinator:Coordinator {
    func start() {
        var vc:UIViewController & Coordinating = MetroPolitaListController()
        vc.coordinator = self
        navigationController?.setViewControllers([vc], animated: false)
    }
    var navigationController: UINavigationController?
    
    func eventOccured(with type: Event,viewModel:ArtObjectViewModel) {
        print(#function)
        let vc: MetropolitanDetailController & Coordinating = MetropolitanDetailController()
        vc.coordinator = self
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
