import UIKit

protocol CreateAccountEventHandler: AnyObject {
    func didTapCloseButton()
    func didTapClickableText()
    func didTouchSignUpWithGoogle()
    func didTouchSignUp(with name: String, email: String, password: String)
}

protocol CreateAccountDataSource: AnyObject {
}

final class CreateAccountController: BaseViewController {
    private let eventHandler: CreateAccountEventHandler
    private let dataSource: CreateAccountDataSource
    
    private lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(didTapCloseButton))
        button.tintColor = .dark30 // Set the color of the button
        return button
    }()
    private let createAccountLabel = UILabel()
    private let signUpWithGoogleButton = GoogleSignInButton(text: "Sign up with Google")
    private let dividerView = DividerView()
    private let orLabelContainerView = UIView()
    private let orLabel = UILabel()
    private let credentialsStackView = UIStackView()
    private let nameTextField = IVTextField(placeholder: "Your name", leadingImage: .person)
    private let emailTextField = IVTextField(placeholder: "Email address", leadingImage: .email)
    private let passwordTextField = IVTextField(placeholder: "Password", leadingImage: .password)
    private let termsAndConditionsView = TermsOfServiceView()
    private let signUpButton = UIButton(configuration: .primary(title: "Sign up"))
    private let allreadyHaveAnAccountView = ClickableTextView(fullText: "Already have an account? Sign in", clickableText: "Sign in")

    init(eventHandler: CreateAccountEventHandler, dataSource: CreateAccountDataSource) {
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
       
       createAccountLabel.text = "Create Account"
       createAccountLabel.textColor = .secondary1
       createAccountLabel.font = .interFont(ofSize: 32, weight: .bold)
       createAccountLabel.textAlignment = .center
       
       orLabel.text = "or"
       orLabel.textColor = .dark30
       orLabel.font = .interFont(ofSize: 14)
       orLabelContainerView.backgroundColor = .white
       
       credentialsStackView.axis = .vertical
       credentialsStackView.spacing = 12
       
       signUpWithGoogleButton.addTarget(self, action: #selector(didTouchSignUpWithGoogle), for: .touchUpInside)
       signUpButton.addTarget(self, action: #selector(didTouchSignUp), for: .touchUpInside)
       
       signUpButton.IVsetEnabled(false, title: "Sign up")
       
       nameTextField.delegate = self
       emailTextField.delegate = self
       
       passwordTextField.delegate = self
       passwordTextField.secured = true
       
       termsAndConditionsView.delegate = self
       allreadyHaveAnAccountView.delegate = self
   }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            createAccountLabel,
            signUpWithGoogleButton,
            dividerView,
            credentialsStackView,
            orLabelContainerView,
            termsAndConditionsView,
            signUpButton,
            allreadyHaveAnAccountView
        ].forEach(view.addSubview)
        
        orLabelContainerView.addSubview(orLabel)
        [
            nameTextField,
            emailTextField,
            passwordTextField,
        ].forEach({ credentialsStackView.addArrangedSubview($0) })
    }
    
   override func constrainSubviews() {
       super.constrainSubviews()
       
       createAccountLabel.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 68, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
       
       signUpWithGoogleButton.autoPinEdge(.top, to: .bottom, of: createAccountLabel, withOffset: 24)
       signUpWithGoogleButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
       signUpWithGoogleButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
       
       orLabelContainerView.autoPinEdge(.top, to: .bottom, of: signUpWithGoogleButton)
       orLabelContainerView.autoAlignAxis(toSuperviewAxis: .vertical)
       
       dividerView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
       dividerView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
       dividerView.autoAlignAxis(.horizontal, toSameAxisOf: orLabelContainerView)
       
       orLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: .zero, left: 24, bottom: .zero, right: 24))
       
       credentialsStackView.autoPinEdge(.top, to: .bottom, of: orLabelContainerView, withOffset: 12)
       credentialsStackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
       credentialsStackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
       
       termsAndConditionsView.autoPinEdge(.top, to: .bottom, of: credentialsStackView, withOffset: 22)
       termsAndConditionsView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
       termsAndConditionsView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
       
       signUpButton.autoPinEdge(.top, to: .bottom, of: termsAndConditionsView, withOffset: 22)
       signUpButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
       signUpButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
       
       allreadyHaveAnAccountView.autoPinEdge(.top, to: .bottom, of: signUpButton, withOffset: 32)
       allreadyHaveAnAccountView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
       allreadyHaveAnAccountView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
       allreadyHaveAnAccountView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0, relation: .greaterThanOrEqual)
   }
    
    @objc private func didTouchSignUpWithGoogle(_ sender: UIButton) {
        eventHandler.didTouchSignUpWithGoogle()
    }
    
    @objc private func didTapCloseButton(_ sender: UIButton) {
        eventHandler.didTapCloseButton()
    }
    
    @objc private func didTouchSignUp(_ sender: UIButton) {
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else { return }
        eventHandler.didTouchSignUp(with: name, email: email, password: password)
    }
}

extension CreateAccountController: CreateAccountViewInterface {
}

extension CreateAccountController: TermsOfServiceViewDelegate {
    func didAgreeToTerms(_ agreed: Bool) {
        print(agreed)
    }
    
    func didTapTermsOfService() {
        
        print("Did tap")
    }
}

extension CreateAccountController: ClickableTextViewDelegate {
    func didTapClickableText() {
        eventHandler.didTapClickableText()
    }
}
extension CreateAccountController: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        let credible = emailTextField.isValid && passwordTextField.isValid && nameTextField.isValid
        signUpButton.IVsetEnabled(credible, title: "Sign up")
    }
}
