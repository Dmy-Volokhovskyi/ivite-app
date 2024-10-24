import UIKit

protocol CheckEmailEventHandler: AnyObject {
}

protocol CheckEmailDataSource: AnyObject {
}

final class CheckEmailController: BaseViewController {
    private let eventHandler: CheckEmailEventHandler
    private let dataSource: CheckEmailDataSource
    
    private let checkEmailLabel = UILabel()
    private let hintLabel = UILabel()
    private let resendButton = ResendButtonView()
    private var countdownTimer: Timer?
    private var remainingSeconds = 59
    
    init(eventHandler: CheckEmailEventHandler, dataSource: CheckEmailDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = .primaryLight10
        
        checkEmailLabel.text = "Check email"
        checkEmailLabel.textColor = .secondary1
        checkEmailLabel.font = .interFont(ofSize: 32, weight: .bold)
        checkEmailLabel.textAlignment = .center
        
        hintLabel.text = "Please check your email and follow the instructions to reset your password."
        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 0
        hintLabel.textColor = .secondary70
        hintLabel.font = .interFont(ofSize: 16)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            checkEmailLabel,
            hintLabel,
            resendButton
        ].forEach(view.addSubview)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        checkEmailLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 68, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
        
        hintLabel.autoPinEdge(.top, to: .bottom, of: checkEmailLabel, withOffset: 12)
        hintLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        hintLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        resendButton.autoPinEdge(.top, to: .bottom, of: hintLabel, withOffset: 24)
        resendButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        resendButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        resendButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0, relation: .greaterThanOrEqual)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resendButton.startCountdown()
    }
}

extension CheckEmailController: CheckEmailViewInterface {
}

final class ResendButtonView: BaseView {

    private let resendButton = UIButton(configuration: .primary(title: "Resend link"))
    private var countdownTimer: Timer?
    private var remainingSeconds = 59

    override func setupView() {
        super.setupView()

        resendButton.addTarget(self, action: #selector(didTapResendButton), for: .touchUpInside)
        addSubview(resendButton)
    }

    override func constrainSubviews() {
        super.constrainSubviews()
        resendButton.autoPinEdgesToSuperviewEdges()
    }

    @objc private func didTapResendButton() {
        startCountdown()
    }

    public func startCountdown() {
        // Disable the button and apply disabled configuration
        resendButton.configuration = .disabledPrimary(title: "Resend link")
        resendButton.isUserInteractionEnabled = false

        // Start the timer
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }

    @objc private func updateCountdown() {
        if remainingSeconds > 0 {
            let title = "Resend link \(String(format: "%02d", remainingSeconds))"
            updateButtonTitle(with: title)
            remainingSeconds -= 1
        } else {
            countdownTimer?.invalidate()
            remainingSeconds = 59

            // Re-enable the button and apply normal configuration
            resendButton.isUserInteractionEnabled = true
            resendButton.configuration = .primary(title: "Resend link")
        }
    }

    private func updateButtonTitle(with title: String) {
        var configuration = resendButton.configuration
        var attributedTitle = AttributedString(title)
        attributedTitle.font = .interFont(ofSize: 14, weight: .semiBold)
        attributedTitle.foregroundColor = UIColor.primaryLight10
        configuration?.attributedTitle = attributedTitle
        resendButton.configuration = configuration
    }
}
