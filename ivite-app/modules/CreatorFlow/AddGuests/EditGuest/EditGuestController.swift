import UIKit

protocol EditGuestEventHandler: AnyObject {
    func editGuest(name: String, email: String)
}

protocol EditGuestDataSource: AnyObject {
    var guest: Guest { get }
}

final class EditGuestController: BaseViewController {
    private let eventHandler: EditGuestEventHandler
    private let dataSource: EditGuestDataSource
    
    private let credentialsStackView = UIStackView()
    private let guestNameTextField = IVTextField(placeholder: "Guest Name")
    private let guestNameEntry = EntryWithTitleView(title: "Guest Name")
    private let guestEmailTextField = IVTextField(placeholder: "Guest Email", validationType: .email)
    private let guestEmailEntry = EntryWithTitleView(title: "Guest Email")
    private let editGuestButton = UIButton(configuration: .primary(title: "Edit guest"))
    
    
    init(eventHandler: EditGuestEventHandler, dataSource: EditGuestDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        super.init()
        
        guestNameTextField.text = dataSource.guest.name
        guestEmailTextField.text = dataSource.guest.email
        
        checkDataCredability()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = .white
        title = "Edit guest"
        
        credentialsStackView.axis = .vertical
        credentialsStackView.spacing = 13
        
        guestNameEntry.setContentView(guestNameTextField)
        guestEmailEntry.setContentView(guestEmailTextField)
        
        guestNameTextField.delegate = self
        guestEmailTextField.delegate = self
        
        editGuestButton.addTarget(self, action: #selector(addGuestTouch), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        view.addSubview(credentialsStackView)
        view.addSubview(editGuestButton)
        
        [
            guestNameEntry,
            guestEmailEntry
        ].forEach(credentialsStackView.addArrangedSubview)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        credentialsStackView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 24, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
        
        editGuestButton.autoPinEdge(.top, to: .bottom, of: credentialsStackView, withOffset: 24)
        editGuestButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        editGuestButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
    }
    
    private func checkDataCredability() {
        let credible = guestNameTextField.isValid && guestEmailTextField.isValid
        editGuestButton.IVsetEnabled(credible, title: "Edit guest")
    }
    
    @objc private func addGuestTouch(_ sender: UIButton) {
        guard let name = guestNameTextField.text,
              let email = guestEmailTextField.text else { return }
        
        eventHandler.editGuest(name: name, email: email)
    }
}

extension EditGuestController: EditGuestViewInterface {
}

extension EditGuestController: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        checkDataCredability()
    }
}
