import UIKit

protocol CreateAccountEventHandler: AnyObject {
}

protocol CreateAccountDataSource: AnyObject {
}

final class CreateAccountController: BaseViewController {
    private let eventHandler: CreateAccountEventHandler
    private let dataSource: CreateAccountDataSource
    
    private let closeButton = UIButton()
    private let createAccountLabel = UILabel()
    private let signInWithGooglebutton = GoogleSignInButton(text: "Sign up with Google")
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
       
       termsAndConditionsView.delegate = self
       allreadyHaveAnAccountView.delegate = self
   }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            closeButton,
            createAccountLabel,
            signInWithGooglebutton,
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
       
       createAccountLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 68, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
       
       signInWithGooglebutton.autoPinEdge(.top, to: .bottom, of: createAccountLabel, withOffset: 24)
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
        print("Did Tap Clickable Text")
    }
}
