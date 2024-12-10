import UIKit

protocol SignInEventHandler: AnyObject {
    func didTouchForgotPassword()
    func didTapCloseButton()
    func didTouchSignIn(with email: String, password: String)
    func didTouchSignInWithGoogle()
    func didTapClickableText()
}

protocol SignInDataSource: AnyObject {
}

final class SignInController: BaseViewController {
    private let eventHandler: SignInEventHandler
    private let dataSource: SignInDataSource
    
    private lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(didTapCloseButton))
        button.tintColor = .dark30 // Set the color of the button
        return button
    }()
    private let welcomeBackLabel = UILabel()
    private let signInWithGoogleButton = GoogleSignInButton(text: "Sign in with Google")
    private let dividerView = DividerView()
    private let orLabelContainerView = UIView()
    private let orLabel = UILabel()
    private let credentialsStackView = UIStackView()
    private let emailTextField = IVTextField(placeholder: "Email address", leadingImage: .email, validationType: .email)
    private let passwordTextField = IVTextField(placeholder: "Password", leadingImage: .password, trailingImage: .eyeOpen)
    private let forgotPasswordButton = UIButton(configuration: .clear(title: "Forgot password?"))
    private let signInButton = UIButton(configuration: .primary(title: "Sign in"))
    private let dontHaveAnAccountView = ClickableTextView(fullText: "Don’t have an account? Sign up", clickableText: "Sign up")
    
    init(eventHandler: SignInEventHandler, dataSource: SignInDataSource) {
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
        
        welcomeBackLabel.text = "Welcome Back!"
        welcomeBackLabel.textColor = .secondary1
        welcomeBackLabel.font = .interFont(ofSize: 32, weight: .bold)
        welcomeBackLabel.textAlignment = .center
        
        orLabel.text = "or"
        orLabel.textColor = .dark30
        orLabel.font = .interFont(ofSize: 14)
        orLabelContainerView.backgroundColor = .white
        
        credentialsStackView.axis = .vertical
        credentialsStackView.spacing = 12
        
        emailTextField.delegate = self
        
        passwordTextField.delegate = self
        passwordTextField.secured = true
        
        signInWithGoogleButton.addTarget(self, action: #selector(didTouchSignInWithGoogle), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(didTouchSignIn), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTouchForgotPassword), for: .touchUpInside)
        
        signInButton.IVsetEnabled(false, title: "Sign in")
        
        dontHaveAnAccountView.delegate = self
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            welcomeBackLabel,
            signInWithGoogleButton,
            dividerView,
            orLabelContainerView,
            credentialsStackView,
            forgotPasswordButton,
            signInButton,
            dontHaveAnAccountView
        ].forEach(view.addSubview)
        
        orLabelContainerView.addSubview(orLabel)
        [
            emailTextField,
            passwordTextField,
        ].forEach({ credentialsStackView.addArrangedSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        welcomeBackLabel.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 68, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
        
        signInWithGoogleButton.autoPinEdge(.top, to: .bottom, of: welcomeBackLabel, withOffset: 24)
        signInWithGoogleButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        signInWithGoogleButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        orLabelContainerView.autoPinEdge(.top, to: .bottom, of: signInWithGoogleButton, withOffset: 16)
        orLabelContainerView.autoAlignAxis(toSuperviewAxis: .vertical)
        
        dividerView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        dividerView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        dividerView.autoAlignAxis(.horizontal, toSameAxisOf: orLabelContainerView)
        
        orLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: .zero, left: 24, bottom: .zero, right: 24))
        
        credentialsStackView.autoPinEdge(.top, to: .bottom, of: orLabelContainerView, withOffset: 12)
        credentialsStackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        credentialsStackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        forgotPasswordButton.autoPinEdge(.top, to: .bottom, of: credentialsStackView, withOffset: 6)
        forgotPasswordButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16, relation: .greaterThanOrEqual)
        forgotPasswordButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        signInButton.autoPinEdge(.top, to: .bottom, of: forgotPasswordButton, withOffset: 22)
        signInButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        signInButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        dontHaveAnAccountView.autoPinEdge(.top, to: .bottom, of: signInButton, withOffset: 32)
        dontHaveAnAccountView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        dontHaveAnAccountView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        dontHaveAnAccountView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0, relation: .greaterThanOrEqual)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func didTouchSignInWithGoogle(_ sender: UIButton) {
        eventHandler.didTouchSignInWithGoogle()
    }
    
    @objc private func didTouchForgotPassword(_ sender: UIButton) {
        eventHandler.didTouchForgotPassword()
    }
    
    @objc private func didTapCloseButton(_ sender: UIButton) {
        eventHandler.didTapCloseButton()
    }
    
    @objc private func didTouchSignIn(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        eventHandler.didTouchSignIn(with: email, password: password)
    }
}

extension SignInController: SignInViewInterface {
}

extension SignInController: ClickableTextViewDelegate {
    func didTapClickableText() {
        eventHandler.didTapClickableText()
    }
}

extension SignInController: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        let credible = emailTextField.isValid && passwordTextField.isValid
        signInButton.IVsetEnabled(credible, title: "Sign in")
    }
}
