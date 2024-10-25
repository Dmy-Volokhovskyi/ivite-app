import UIKit

protocol ForgotPasswordEventHandler: AnyObject {
    func didPressSend()
    func didTapCloseButton()
}

protocol ForgotPasswordDataSource: AnyObject {
}

final class ForgotPasswordController: BaseViewController {
    private let eventHandler: ForgotPasswordEventHandler
    private let dataSource: ForgotPasswordDataSource
    
    private lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(didTapCloseButton))
        button.tintColor = .dark30 // Set the color of the button
        return button
    }()

    private let forgotPasswordLabel = UILabel()
    private let hintLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let emailTextField = IVTextField(placeholder: "Email address", leadingImage: .email, validationType: .email)
    private let sendButton = UIButton(configuration: .primary(title: "Send"))
    private let cancelButton = UIButton(configuration: .secondary(title: "Cancel"))

    init(eventHandler: ForgotPasswordEventHandler, dataSource: ForgotPasswordDataSource) {
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
       
       navigationItem.rightBarButtonItem = closeButton
       navigationItem.hidesBackButton = true
       
       forgotPasswordLabel.text = "Forgot Password?"
       forgotPasswordLabel.textColor = .secondary1
       forgotPasswordLabel.font = .interFont(ofSize: 32, weight: .bold)
       forgotPasswordLabel.textAlignment = .center
       
       hintLabel.text = "Enter your email address below and we will send you an email to reset your password."
       hintLabel.textAlignment = .center
       hintLabel.numberOfLines = 0
       hintLabel.textColor = .secondary70
       hintLabel.font = .interFont(ofSize: 16)
       
       sendButton.addTarget(self, action: #selector(didTouchSendButton), for: .touchUpInside)
       
       buttonStackView.axis = .vertical
       buttonStackView.spacing = 12
   }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            forgotPasswordLabel,
            hintLabel,
            emailTextField,
            buttonStackView,
        ].forEach(view.addSubview)
        
        [
            sendButton,
            cancelButton
        ].forEach({ buttonStackView.addArrangedSubview($0) })
    }
    
   override func constrainSubviews() {
       super.constrainSubviews()
       
       forgotPasswordLabel.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 68, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
       
       hintLabel.autoPinEdge(.top, to: .bottom, of: forgotPasswordLabel, withOffset: 12)
       hintLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
       hintLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
       
       emailTextField.autoPinEdge(.top, to: .bottom, of: hintLabel, withOffset: 24)
       emailTextField.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
       emailTextField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
       
       buttonStackView.autoPinEdge(.top, to: .bottom, of: emailTextField, withOffset: 24)
       buttonStackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
       buttonStackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
       buttonStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0, relation: .greaterThanOrEqual)
   }
    
    @objc private func didTouchSendButton(_ sender: UIButton) {
        eventHandler.didPressSend()
    }
    
    @objc private func didTapCloseButton(_ sender: UIButton) {
        eventHandler.didTapCloseButton()
    }
}

extension ForgotPasswordController: ForgotPasswordViewInterface {
}
