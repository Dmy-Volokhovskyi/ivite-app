import Foundation
import PDFKit

protocol DataPrivacyViewInterface: AnyObject {
    func updatePDF(with document: PDFDocument)
}

final class DataPrivacyPresenter: BasePresenter {
    private let interactor: DataPrivacyInteractor
    let router: DataPrivacyRouter
    weak var viewInterface: DataPrivacyController?
    
    init(router: DataPrivacyRouter, interactor: DataPrivacyInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension DataPrivacyPresenter: DataPrivacyEventHandler {
    func viewDidLoad() {
        Task {
            await interactor.fetchPrivacyPolicy()
        }
    }
    
    func viewWillAppear() {
        print("DataPrivacy")
    }
}

extension DataPrivacyPresenter: DataPrivacyDataSource {
}

extension DataPrivacyPresenter: DataPrivacyInteractorDelegate {
    func didDownloadPrivacyPolicy() {
        guard let privacyPolicy = interactor.privacyPolicy else { return }
        viewInterface?.updatePDF(with: privacyPolicy)
    }
}
