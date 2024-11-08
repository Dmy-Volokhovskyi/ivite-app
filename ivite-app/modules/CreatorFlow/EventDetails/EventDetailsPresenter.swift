import Foundation

protocol EventDetailsViewInterface: AnyObject {
    func updateCohostView()
    func updateDateView(with time: String, date: String)
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
    func didTouchNextButton() {
        interactor.eventDetailsDelegate?.didEndEventDetails()
    }
    
    func didTouchBackButton() {
        router.popVC()
    }
    
    func didTouchMenu(for coHost: CoHost) {
        guard let controller = viewInterface else { return }
        router.presentActionAlertController(from: controller)
    }
    
    func didTapPickDateButton() {
      guard let controller = viewInterface else { return }
        router.presentDatePickerViewController(from: controller, delegate: self)
    }
    
    func didTapAddCoHostButton() {
        guard let controller = viewInterface else { return }
        router.presentAddCoHostViewController(from: controller, delegate: self)
    }
}

extension EventDetailsPresenter: EventDetailsDataSource {
    var coHosts: [CoHost] {
        interactor.eventDetailsViewModel.coHosts
    }
    var model: EventDetailsViewModel { interactor.eventDetailsViewModel }
}

extension EventDetailsPresenter: EventDetailsInteractorDelegate {
}

extension EventDetailsPresenter: AddCoHostViewControllerDelegate {
    func didAddCoHost(coHost: CoHost) {
        interactor.eventDetailsViewModel.coHosts.append(coHost)
        viewInterface?.updateCohostView()
    }
}

extension EventDetailsPresenter: DatePickerViewControllerDelegate {
    func didPickDate(_ date: Date) {
        interactor.eventDetailsViewModel.date = date
        viewInterface?.updateDateView(with: interactor.eventDetailsViewModel.formattedTime(), date: interactor.eventDetailsViewModel.formattedDate())
        print(date)
    }
}
