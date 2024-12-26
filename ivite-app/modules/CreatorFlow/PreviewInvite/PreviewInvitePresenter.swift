import UIKit

protocol PreviewInviteViewInterface: AnyObject {
}

final class PreviewInvitePresenter: BasePresenter {
    private let interactor: PreviewInviteInteractor
    let router: PreviewInviteRouter
    weak var viewInterface: PreviewInviteController?
    
    init(router: PreviewInviteRouter, interactor: PreviewInviteInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
    func openLinkInSafari(url: URL) {
        let safariAction = UIAlertAction(title: "Go to Safari", style: .default) { _ in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        router.showSystemAlert(
            title: "Open Link",
            message: "Do you want to open this link in Safari?",
            actions: [safariAction, cancelAction]
        )
    }
}

extension PreviewInvitePresenter: PreviewInviteEventHandler {
    func seeAllGuestsButtonTapped() {
        
    }
    
    func didTapLinkButton(_ gift: Gift) {
        guard let link = gift.link, let url = URL(string: link) else { return }
        openLinkInSafari(url: url)
    }
    
    func didTapBringButton(_ gift: Gift) {
//        openLinkInSafari(url: gift.link)
    }
    
    var creatorFlowModel: CreatorFlowModel { interactor.creatorFlowModel }
}

extension PreviewInvitePresenter: PreviewInviteDataSource {
    var previewMode: Bool {
        interactor.previewMode
    }
    
    var user: IVUser? { interactor.user }
}

extension PreviewInvitePresenter: PreviewInviteInteractorDelegate {
}
