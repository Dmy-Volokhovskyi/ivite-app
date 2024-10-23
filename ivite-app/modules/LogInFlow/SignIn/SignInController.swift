import UIKit

protocol SignInEventHandler: AnyObject {
    func didTouchForgotPassword()
}

protocol SignInDataSource: AnyObject {
}

final class SignInController: BaseViewController {
    private let eventHandler: SignInEventHandler
    private let dataSource: SignInDataSource
    
    private let closeButton = UIButton()
    private let welcomeBackLabel = UILabel()
    private let signInWithGooglebutton = UIButton()
    private let dividerView = DividerView()
    private let orLabelContainerView = UIView()
    private let orLabel = UILabel()
    private let credentialsStackView = UIStackView()
    private let emailTextField = IVTextField(placeholder: "Email address", leadingImage: .email)
    private let passwordTextField = IVTextField(placeholder: "Password", leadingImage: .password)
    private let forgotPasswordButton = UIButton(configuration: .clear(title: "Forgot password?"))
    private let signInButton = UIButton(configuration: .primary(title: "Sign up"))
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
       
       forgotPasswordButton.addTarget(self, action: #selector(didTouchForgotPassword), for: .touchUpInside)
       
       dontHaveAnAccountView.delegate = self
   }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            closeButton,
            welcomeBackLabel,
            signInWithGooglebutton,
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
       
       welcomeBackLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 68, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
       
       signInWithGooglebutton.autoPinEdge(.top, to: .bottom, of: welcomeBackLabel, withOffset: 24)
       signInWithGooglebutton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
       signInWithGooglebutton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
       
       orLabelContainerView.autoPinEdge(.top, to: .bottom, of: signInWithGooglebutton)
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
    
    @objc private func didTouchForgotPassword() {
        print("Did Touch Forgot Password")
        eventHandler.didTouchForgotPassword()
    }
}

extension SignInController: SignInViewInterface {
}

extension SignInController: ClickableTextViewDelegate {
    func didTapClickableText() {
        print("Did Tap Clickable Text")
    }
}
