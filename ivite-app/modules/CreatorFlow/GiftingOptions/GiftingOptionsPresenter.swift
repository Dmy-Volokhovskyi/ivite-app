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
    
    func showEditGift(for gift: Gift) {
        let view = EditGiftView(gift: gift)
        view.delegate = self
        router.showFloatingView(customView: view)
    }
    
    func deleteGift(for gift: Gift) {
        let deleteAction = ActionItem(title: "Delete item", image: nil, isPrimary: true) {
            self.remove(gift: gift)
            print("Delete tapped")
        }
        
        let cancelAction = ActionItem(title: "Cancel", image: nil, isPrimary: false) {
            self.router.dismiss(completion: nil)
        }
        
        router.showAlert(alertItem: AlertItem(title: "Delete a gift from the list?", message: nil, actions: [deleteAction, cancelAction]))
    }
    
    private func remove(gift: Gift) {
        guard let index = interactor.gifts.firstIndex(where: { $0.id == gift.id }) else  { return }
        interactor.gifts.remove(at: index)
        router.dismiss(completion: { self.viewInterface?.updateGifts(with: self.interactor.gifts) })
    }
}

extension GiftingOptionsPresenter: GiftingOptionsEventHandler {
    func didTouchMenuButton(for gift: Gift) {
        let editAction = ActionItem(title: "Edit", image: UIImage(systemName: "pencil"), isPrimary: true) {
            self.showEditGift(for: gift)
        }
        
        let deleteAction = ActionItem(title: "Delete", image: UIImage(systemName: "trash"), isPrimary: true) {
            self.deleteGift(for: gift)
        }
        
        router.showActions(actions: [editAction, deleteAction])
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
        interactor.giftingOptionsDelegate?.didEndGiftingOptions(gifts: interactor.gifts)
    }
}

extension GiftingOptionsPresenter: GiftingOptionsDataSource {
    var gifts: [Gift] {
        interactor.gifts
    }
}

extension GiftingOptionsPresenter: GiftingOptionsInteractorDelegate {
}

extension GiftingOptionsPresenter: EditGiftViewDelegate {
    func giftRegistryViewDidRequestPhotoLibraryAccess(_ view: GiftRegistryView) {
        Task {
            guard let topViewController = await UIApplication.shared.topMostViewController else {
                print("Error: Could not find the top-most view controller.")
                return
            }
            await PhotoLibraryManager.shared.requestPhotoLibraryAccess(from: topViewController) { selectedImage in
                view.displayImage(selectedImage) // Add this method in your custom view if needed
            }
        }
    }
    
    func didEdditGift(_ gift: Gift) {
        guard let index = interactor.gifts.firstIndex(where: { $0.id == gift.id }) else  { return }
        interactor.gifts[index] = gift
        viewInterface?.updateGifts(with: interactor.gifts)
        router.dismiss(completion: nil)
    }
}

extension UIApplication {
    var topMostViewController: UIViewController? {
        guard let rootViewController = keyWindow?.rootViewController else {
            return nil
        }
        return getTopViewController(from: rootViewController)
    }
    
    private func getTopViewController(from viewController: UIViewController) -> UIViewController? {
        if let presentedViewController = viewController.presentedViewController {
            return getTopViewController(from: presentedViewController)
        }
        if let navigationController = viewController as? UINavigationController {
            return navigationController.visibleViewController
        }
        if let tabBarController = viewController as? UITabBarController {
            return tabBarController.selectedViewController
        }
        return viewController
    }
}
