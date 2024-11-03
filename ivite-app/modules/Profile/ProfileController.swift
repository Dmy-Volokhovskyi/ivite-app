import UIKit

protocol ProfileEventHandler: AnyObject {
    func didTouchShowProfile()
    func didSelectMenuItem(menuItem: ProfileMenuItem)
}

protocol ProfileDataSource: AnyObject {
    var user: IVUser? { get }
}

final class ProfileController: BaseScrollViewController {
    private let eventHandler: ProfileEventHandler
    private let dataSource: ProfileDataSource
    
    private let accountSettingsLabel = UILabel()
    private let profileDetailView: ProfileDetailView
    private let dividerView = DividerView(topSpace: 24, bottomSpace: 24)
    private let proVersionBanner = UIView()
    private let profileMenuView = ProfileMenuView()
    
    init(eventHandler: ProfileEventHandler, dataSource: ProfileDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        self.profileDetailView = ProfileDetailView(user: dataSource.user)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = .white
        
        accountSettingsLabel.text = "Account Settings"
        accountSettingsLabel.textColor = .secondary1
        accountSettingsLabel.font = .interFont(ofSize: 24, weight: .bold)
        
        profileDetailView.delegate = self
        profileMenuView.delegate = self
    }
    
    override func addSubviews() {
        super.addSubviews()

        [
            accountSettingsLabel,
            profileDetailView,
            dividerView,
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
        profileMenuView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
    }
}

extension ProfileController: ProfileViewInterface {
}

extension ProfileController: ProfileViewDelegate {
    func didTouchShowProfile() {
        eventHandler.didTouchShowProfile()
    }
}

extension ProfileController: ProfileMenuViewDelegate {
    func profileMenuView(_ profileMenuView: ProfileMenuView, didSelectMenuItem menuItem: ProfileMenuItem) {
        eventHandler.didSelectMenuItem(menuItem: menuItem)
    }
}
