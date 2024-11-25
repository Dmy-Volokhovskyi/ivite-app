import UIKit

protocol AddNewGuestEventHandler: AnyObject {
    func addGuest(name: String, email: String)
}

protocol AddNewGuestDataSource: AnyObject {
}

final class AddNewGuestController: BaseViewController {
    private let eventHandler: AddNewGuestEventHandler
    private let dataSource: AddNewGuestDataSource
    
    private let credentialsStackView = UIStackView()
    private let guestNameTextField = IVTextField(placeholder: "Guest Name")
    private let guestNameEntry = EntryWithTitleView(title: "Guest Name")
    private let guestEmailTextField = IVTextField(placeholder: "Guest Email", validationType: .email)
    private let guestEmailEntry = EntryWithTitleView(title: "Guest Email")
    private let addGuestButton = UIButton(configuration: .primary(title: "Add Guest"))
    
    init(eventHandler: AddNewGuestEventHandler, dataSource: AddNewGuestDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = .white
        
        credentialsStackView.axis = .vertical
        credentialsStackView.spacing = 13
        
        guestNameEntry.setContentView(guestNameTextField)
        guestEmailEntry.setContentView(guestEmailTextField)
        
        addGuestButton.IVsetEnabled(false, title: "Add Guest")
        guestNameTextField.delegate = self
        guestEmailTextField.delegate = self
        
        addGuestButton.addTarget(self, action: #selector(addGuestTouch), for: .touchUpInside)
        
        title = "Add new guest"
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        view.addSubview(credentialsStackView)
        view.addSubview(addGuestButton)
        
        [
            guestNameEntry,
            guestEmailEntry
        ].forEach(credentialsStackView.addArrangedSubview)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        credentialsStackView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 24, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
        
        addGuestButton.autoPinEdge(.top, to: .bottom, of: credentialsStackView, withOffset: 24)
        addGuestButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        addGuestButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
    }
    
    private func checkDataCredability() {
        let credible = guestNameTextField.isValid && guestEmailTextField.isValid
        addGuestButton.IVsetEnabled(credible, title: "Add Guest")
    }
    
    @objc private func addGuestTouch(_ sender: UIButton) {
        guard let name = guestNameTextField.text,
              let email = guestEmailTextField.text else { return }
        
        eventHandler.addGuest(name: name, email: email)
    }
}

extension AddNewGuestController: AddNewGuestViewInterface {
}

extension AddNewGuestController: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        checkDataCredability()
    }
}
