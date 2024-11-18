import Foundation

protocol EventDetailsViewInterface: AnyObject {
    func updateCohostView()
    func updateDateView(with time: String, date: String)
    func updateTimezone(with timeZone: String)
    func isReadyToSaveChanges(ready: Bool)
    func updateBringList()
}

final class EventDetailsPresenter: BasePresenter {
    private let interactor: EventDetailsInteractor
    let router: EventDetailsRouter
    weak var viewInterface: EventDetailsController?
    
    init(router: EventDetailsRouter, interactor: EventDetailsInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension EventDetailsPresenter: EventDetailsEventHandler {
    func requestDeleteItem(for bringItem: BringListItem) {
        let deleteAction = ActionItem(title: "Delete item", image: nil, isPrimary: true) {
            self.remove(bringItem: bringItem)
            print("Delete tapped")
        }
        
        let cancelAction = ActionItem(title: "Cancel", image: nil, isPrimary: false) {
            self.router.dismiss(completion: nil)
        }
        
        router.showAlert(alertItem: AlertItem(title: "Remove an item from the Bring list?", message: "Are you sure you want to delete this co-host?", actions: [deleteAction, cancelAction]))
    }
    
    func didSelectTimeZone(_ timeZone: String) {
        interactor.eventDetailsViewModel.timeZone = timeZone
        viewInterface?.updateTimezone(with: timeZone)
    }
    
    func didTouchNextButton() {
        interactor.eventDetailsDelegate?.didEndEventDetails()
    }
    
    func didTouchBackButton() {
        router.popVC()
    }
    
    func didTouchMenu(for coHost: CoHost) {
        let editAction = ActionItem(title: "Edit", image: .edit, isPrimary: true) {
            let view = EdditCoHostView(coHost: coHost)
            view.delegate = self
            self.router.showFloatingView(customView: view)
            print("Edit tapped")
        }
        
        let deleteAction = ActionItem(title: "Delete", image: .orangeTrash.withRenderingMode(.alwaysTemplate).withTintColor(.secondary1), isPrimary: true) {
            self.remove(coHost: coHost)
            print("Delete tapped")
        }
        router.showActions(actions: [editAction, deleteAction])
    }
    
    func didTapPickDateButton() {
        guard let controller = viewInterface else { return }
        router.presentDatePickerViewController(from: controller, delegate: self)
    }
    
    func didTapAddCoHostButton() {
        let view = AddCoHostView()
        view.delegate = self
        self.router.showFloatingView(customView: view)
    }
    
    private func remove(coHost: CoHost) {
        guard let index = interactor.eventDetailsViewModel.coHosts.firstIndex(where: { $0.id == coHost.id }) else  { return }
        interactor.eventDetailsViewModel.coHosts.remove(at: index)
        viewInterface?.updateCohostView()
    }
    
    private func remove(bringItem: BringListItem) {
        guard let index = interactor.eventDetailsViewModel.bringList.firstIndex(where: { $0.id == bringItem.id }) else  { return }
        interactor.eventDetailsViewModel.bringList.remove(at: index)
        router.dismiss(completion: { self.viewInterface?.updateBringList() })
    }
}

extension EventDetailsPresenter: EventDetailsDataSource {
    var selectedTimeZone: String? {
        interactor.eventDetailsViewModel.timeZone
    }
    
    var coHosts: [CoHost] {
        interactor.eventDetailsViewModel.coHosts
    }
    var model: EventDetailsViewModel { interactor.eventDetailsViewModel }
}

extension EventDetailsPresenter: EventDetailsInteractorDelegate {
    func isReadyToSaveChanges(ready: Bool) {
        viewInterface?.isReadyToSaveChanges(ready: ready)
    }
}

extension EventDetailsPresenter: AddCoHostViewDelegate {
    func didAddCoHost(coHost: CoHost) {
        interactor.eventDetailsViewModel.coHosts.append(coHost)
        viewInterface?.updateCohostView()
        router.dismiss(completion: nil)
    }
}

extension EventDetailsPresenter: EdditCoHostViewDelegate {
    func didEdditCoHost(coHost: CoHost) {
        guard let index = interactor.eventDetailsViewModel.coHosts.firstIndex(where: { $0.id == coHost.id }) else  { return }
        interactor.eventDetailsViewModel.coHosts[index] = coHost
        viewInterface?.updateCohostView()
        router.dismiss(completion: nil)
    }
}

extension EventDetailsPresenter: DatePickerViewControllerDelegate {
    func didPickDate(_ date: Date) {
        interactor.eventDetailsViewModel.date = date
        viewInterface?.updateDateView(with: interactor.eventDetailsViewModel.formattedTime(), date: interactor.eventDetailsViewModel.formattedDate())
    }
}
