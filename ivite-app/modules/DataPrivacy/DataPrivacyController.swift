import UIKit
import PDFKit

protocol DataPrivacyEventHandler: AnyObject {
    func viewWillAppear()
    func viewDidLoad()
}

protocol DataPrivacyDataSource: AnyObject {
}

final class DataPrivacyController: BaseViewController {
    private let eventHandler: DataPrivacyEventHandler
    private let dataSource: DataPrivacyDataSource
    
    private let backButton = UIButton(configuration: .image(image: .chewroneBack))
    private let titleLabel = UILabel()
    private let pdfView = PDFView()
    
    init(eventHandler: DataPrivacyEventHandler, dataSource: DataPrivacyDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        
        titleLabel.text = "Data Privacy"
        titleLabel.font = .interFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .secondary1
        
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.backgroundColor = .dark10
        
        backButton.addTarget(self, action: #selector(didTouchBack), for: .touchUpInside)
        view.backgroundColor = .white
    }
    
    override func addSubviews() {
        super.addSubviews()
        [
            backButton,
            titleLabel,
            pdfView].forEach { view.addSubview($0) }
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        backButton.autoPinEdge(toSuperviewSafeArea: .top, withInset: 8)
        backButton.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 16)
        
        titleLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 8)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 16)
        titleLabel.autoPinEdge(.leading, to: .trailing, of: backButton, withOffset: 16)
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: backButton)
        
        pdfView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 24)
        pdfView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16), excludingEdge: .top)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventHandler.viewWillAppear()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc private func didTouchBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func update(with document: PDFDocument) {
        pdfView.document = document
    }
}

extension DataPrivacyController: DataPrivacyViewInterface {
    func updatePDF(with document: PDFDocument) {
        DispatchQueue.main.async {
            self.pdfView.document = document
        }
    }
}
