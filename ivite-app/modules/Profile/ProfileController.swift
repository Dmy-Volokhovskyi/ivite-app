import UIKit

protocol ProfileEventHandler: AnyObject {
    func viewDidAppear()
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
    private let proVersionBannerStackView = UIStackView()
    private let invitesLeftView = InvitesLeftView()
    private let proVersionBanner = ProVersionBannerView()
    private let spacerView = UIView()
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
        
        proVersionBannerStackView.axis = .vertical
        proVersionBannerStackView.spacing = 24
        
        invitesLeftView.configure(invitesLeft: dataSource.user?.remainingInvites ?? 0)
    }
    
    override func addSubviews() {
        super.addSubviews()

        [
            accountSettingsLabel,
            profileDetailView,
            proVersionBannerStackView,
            dividerView,
            profileMenuView
        ].forEach({ contentView.addSubview($0) })
        
        proVersionBannerStackView.addArrangedSubview(invitesLeftView)
        proVersionBannerStackView.addArrangedSubview(proVersionBanner)
        proVersionBannerStackView.addArrangedSubview(spacerView)
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
        
        proVersionBannerStackView.autoPinEdge(.top, to: .bottom, of: dividerView)
        proVersionBannerStackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        proVersionBannerStackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        profileMenuView.autoPinEdge(.top, to: .bottom, of: proVersionBannerStackView)
        profileMenuView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        profileMenuView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        profileMenuView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
        
        spacerView.autoSetDimension(.height, toSize: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventHandler.viewDidAppear()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension ProfileController: ProfileViewInterface {
    func update(_ user: IVUser) {
        DispatchQueue.main.async {
            self.profileDetailView.setUpProfile(for: user)
            
            self.proVersionBannerStackView.subviews.forEach { $0.isHidden = user.isPremium }
        }
    }
    
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
