import UIKit

protocol ProfileEventHandler: AnyObject {
    func didTouchShowProfile()
}

protocol ProfileDataSource: AnyObject {
}

final class ProfileController: BaseScrollViewController {
    private let eventHandler: ProfileEventHandler
    private let dataSource: ProfileDataSource
    
    private let accountSettingsLabel = UILabel()
    private let profileDetailView = ProfileDetailView(user: User(firstName: "Jack"))
    private let dividerView = DividerView(topSpace: 24, bottomSpace: 24)
    private let proVersionBanner = UIView()
    private let profileMenuView = ProfileMenuView()
    
    init(eventHandler: ProfileEventHandler, dataSource: ProfileDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    override func setupView() {
        super.setupView()
        
        accountSettingsLabel.text = "Account Settings"
        accountSettingsLabel.textColor = .secondary1
        accountSettingsLabel.font = .interFont(ofSize: 24, weight: .bold)
    }
    
    override func addSubviews() {
        super.addSubviews()

        [
            accountSettingsLabel,
            profileDetailView,
            dividerView,
//            invitesLeftView,
            proVersionBanner,
            profileMenuView
        ].forEach({ contentView.addSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        accountSettingsLabel.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 32, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
        
        profileDetailView.autoPinEdge(.top, to: .bottom, of: accountSettingsLabel, withOffset: 24)
        profileDetailView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        profileDetailView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        dividerView.autoPinEdge(.top, to: .bottom, of: profileDetailView)
        dividerView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        dividerView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        proVersionBanner.autoPinEdge(.top, to: .bottom, of: dividerView)
        proVersionBanner.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        proVersionBanner.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        profileMenuView.autoPinEdge(.top, to: .bottom, of: proVersionBanner)
        profileMenuView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        profileMenuView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
    }
}

extension ProfileController: ProfileViewInterface {
}

extension ProfileController: ProfileViewDelegate {
    func didTouchShowProfile() {
        eventHandler.didTouchShowProfile()
    }
}
