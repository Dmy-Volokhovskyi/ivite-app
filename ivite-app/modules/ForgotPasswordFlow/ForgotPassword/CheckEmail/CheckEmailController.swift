import UIKit

protocol CheckEmailEventHandler: AnyObject {
    func didTapResendButton()
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
        
        resendButton.delegate = self
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

extension CheckEmailController: ResendButtonViewDelegate {
    func didTapResendButton() {
        eventHandler.didTapResendButton()
    }
}
