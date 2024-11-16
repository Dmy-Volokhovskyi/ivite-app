import UIKit

protocol GiftingOptionsViewInterface: AnyObject {
    func updateGifts(with gifts: [Gift])
}

final class GiftingOptionsPresenter: BasePresenter {
    private let interactor: GiftingOptionsInteractor
    let router: GiftingOptionsRouter
    weak var viewInterface: GiftingOptionsController?
    
    init(router: GiftingOptionsRouter, interactor: GiftingOptionsInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension GiftingOptionsPresenter: GiftingOptionsEventHandler {
    func didTouchMenuButton(for gift: Gift) {
        guard let viewInterface else { return }
        let editAction = ActionItem(title: "Edit", image: UIImage(systemName: "pencil"), isPrimary: true) {
        #warning("Present edit gift view")
            print("Edit tapped")
        }
        
        let deleteAction = ActionItem(title: "Delete", image: UIImage(systemName: "trash"), isPrimary: true) {
            guard let index = self.interactor.gifts.firstIndex(where: { $0.id == gift.id }) else { return }
            self.interactor.gifts.remove(at: index)
            viewInterface.updateGifts(with: self.interactor.gifts)
        }
        router.presentActionAlertController(from: viewInterface, with: [editAction, deleteAction])
    }
    
    func didAddGift(gift: Gift) {
        interactor.gifts.append(gift)
        viewInterface?.updateGifts(with: interactor.gifts)
    }
    
    func didTouchDeletePhotoButton() {
        print("delete photo")
    }
    
    func didTouchBackButton() {
        router.popVC()
    }
    
    func didTouchNextButton() {
        interactor.giftingOptionsDelegate?.didEndGiftingOptions()
    }
}

extension GiftingOptionsPresenter: GiftingOptionsDataSource {
    var gifts: [Gift] {
        interactor.gifts
    }
}

extension GiftingOptionsPresenter: GiftingOptionsInteractorDelegate {
}
