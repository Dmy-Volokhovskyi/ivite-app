import Foundation

final class GiftingOptionsBuilder: BaseBuilder {
    func make(gifts: [Gift],
              giftingOptionsDelegate: GiftingOptionsDelegate) -> GiftingOptionsController {
        let router = GiftingOptionsRouter()
        let interactor = GiftingOptionsInteractor(gifts: gifts,
                                                  giftingOptionsDelegate: giftingOptionsDelegate, serviceProvider: serviceProvider)
        let presenter = GiftingOptionsPresenter(router: router, interactor: interactor)
        let controller = GiftingOptionsController(eventHandler: presenter, dataSource: presenter)

        presenter.viewInterface = controller

        interactor.delegate = presenter
        
        router.controller = controller

        return controller
    }
}
