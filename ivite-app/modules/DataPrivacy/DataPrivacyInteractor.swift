import PDFKit

protocol DataPrivacyInteractorDelegate: AnyObject {
    func didDownloadPrivacyPolicy()
}

final class DataPrivacyInteractor: BaseInteractor {
    weak var delegate: DataPrivacyInteractorDelegate?
    
    var privacyPolicy: PDFDocument?
    func fetchPrivacyPolicy() async {
        do {
            let pdfData = try await serviceProvider.firestoreManager.downloadPDF(.privacyPolicy)
            
            if let pdfDocument = PDFDocument(data: pdfData) {
                privacyPolicy = pdfDocument
                delegate?.didDownloadPrivacyPolicy()
            } else {
                print("Error: Could not create PDFDocument from data.")
            }
            
        } catch {
            print("Failed to download PDF: \(error)")
        }
    }

}
