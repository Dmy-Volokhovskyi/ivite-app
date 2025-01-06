import UIKit

protocol DataPrivacyEventHandler: AnyObject {
    func viewWillAppear()
}

protocol DataPrivacyDataSource: AnyObject {
}

final class DataPrivacyController: BaseScrollViewController {
    private let eventHandler: DataPrivacyEventHandler
    private let dataSource: DataPrivacyDataSource
    
    private let backButton = UIButton(configuration: .image(image: .chewroneBack))
    private let titleLabel = UILabel()
    
    private let dataPrivacyBackgroundView = UIView()
    private let dataPrivacyTitleLabel = UILabel()
    private let dataPrivacyDescriptionLabel = UILabel()
    
    init(eventHandler: DataPrivacyEventHandler, dataSource: DataPrivacyDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        titleLabel.text = "Data privacy"
        titleLabel.font = .interFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .secondary1
        
        dataPrivacyBackgroundView.layer.cornerRadius = 14
        dataPrivacyBackgroundView.backgroundColor = .dark10
        
        dataPrivacyTitleLabel.text = "Data privacy"
        dataPrivacyTitleLabel.textColor = .secondary1
        dataPrivacyTitleLabel.font = .interFont(ofSize: 24, weight: .bold)
        
        dataPrivacyDescriptionLabel.text = """
        This website is operated by IVITE, a registered trademark of IVITE, represented by the natural person 3536713071, Artem Khmil. Important: by providing personal data to IVITE and/or through the website https://ivite.app/ and https://postcard.ivite.app/ , the user authorizes that their personal data be used and processed by IVITE under the terms and conditions described below.
        
        1. Scope
        This Privacy Policy covers the IVITE digital platform owned by IVITE.
        IVITE is accessible through the https://ivite.app/ and https://postcard.ivite.app/.
        
        2. Warning
        Browsing, registering, and using the IVITE platform is subject to acceptance of the conditions set out in this policy. If you do not agree with it, you must leave the site.
        
        3. Privacy and Security Policy
        IVITE cares about your privacy and protects the information transmitted to it.
        IVITE establishes compliance with the principles of legislation and data protection, respecting all national laws and regulations.
        Links to third party websites may be made available on these platforms for greater user convenience. IVITE is not responsible for, approves or in any way supports or subscribes to the formal content of these websites or the websites linked or referred to in them.
        IVITE is not responsible for any users of this website for any damages arising from the use or disclosure of the information contained therein.
        
        4. Cookies
        4.1. What are cookies?
        "Cookies" are a text string stored in a specific file and included in Hypertext Transfer Protocol (HTTP – Hypertext Transfer Protocol) requests and responses.
        It allows the recording of status information while browsing and when returning to a specific website, maintaining HTTP sessions.
        
        ... (Continue with the rest of your policy text)
        """
        
        dataPrivacyDescriptionLabel.numberOfLines = 0
        dataPrivacyDescriptionLabel.textColor = .secondary70
        dataPrivacyDescriptionLabel.font = .interFont(ofSize: 16, weight: .regular)
        
        backButton.addTarget(self, action: #selector(didTouchBack), for: .touchUpInside)
        view.backgroundColor = .white
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            backButton,
            titleLabel,
            dataPrivacyBackgroundView
        ].forEach({ contentView.addSubview($0) })
        
        dataPrivacyBackgroundView.addSubview(dataPrivacyTitleLabel)
        dataPrivacyBackgroundView.addSubview(dataPrivacyDescriptionLabel)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        backButton.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        backButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        titleLabel.autoPinEdge(.leading, to: .trailing, of: backButton, withOffset: 16)
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: backButton)
        
        dataPrivacyBackgroundView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 24)
        dataPrivacyBackgroundView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16), excludingEdge: .top)
        
        dataPrivacyTitleLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16), excludingEdge: .bottom)
        
        dataPrivacyDescriptionLabel.autoPinEdge(.top, to: .bottom, of: dataPrivacyTitleLabel, withOffset: 16)
        dataPrivacyDescriptionLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16), excludingEdge: .top)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventHandler.viewWillAppear()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc private func didTouchBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension DataPrivacyController: DataPrivacyViewInterface {
}
