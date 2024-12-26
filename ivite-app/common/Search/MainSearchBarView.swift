//
//  MainSearchBarView.swift
//  ivite-app
//
//  Created by GoApps Developer on 04/09/2024.
//

import UIKit

protocol MainSearchBarViewDelegate: AnyObject {
    func didTapLogInButton()
    func searchFieldTextDidChange(_ text: String?)
}
@MainActor
final class MainSearchBarView: BaseView {
    private let stackView = UIStackView()
    private let logoImage = UIImageView(image: .logo)
    private let searchButton = DynamicSearchBar()
    private let profileImage = UIImageView(image: .test)
    private let logInButton = UIButton(configuration: .secondary(title: "Log in"))
    
    var isLoggedIn = false {
        didSet {
            logInButton.isHidden = isLoggedIn
            profileImage.isHidden = !isLoggedIn
        }
    }
    
    weak var delegate: MainSearchBarViewDelegate?
    
    init(isLoggedIn: Bool = false, profileImageURL: String?) {
        self.isLoggedIn = isLoggedIn
        super.init()
        
        logInButton.isHidden = isLoggedIn
        profileImage.isHidden = !isLoggedIn
        profileImage.layer.cornerRadius = 22
        profileImage.clipsToBounds = true
        
        let url = URL(string: profileImageURL ?? "")
        profileImage.sd_setImage(with: url, placeholderImage: .userAdd)
        
        searchButton.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAuthStateChange),
                                               name: .authStateDidChange,
                                               object: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        stackView.spacing = 12
        
        logInButton.addTarget(self, action: #selector(didTouchLogInButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(stackView)
        
        [
            logoImage,
            searchButton,
            profileImage,
            logInButton
        ].forEach({ stackView.addArrangedSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        logoImage.autoSetDimensions(to: CGSize(width: 44, height: 44))
        
        profileImage.autoSetDimensions(to: CGSize(width: 44, height: 44))
        
        logInButton.setContentCompressionResistancePriority(.init(999), for: .horizontal)
        
        stackView.autoPinEdgesToSuperviewEdges()
    }
    
    public func updateProfileImage(_ profileImageURL: String?) {
        let url = URL(string: profileImageURL ?? "")
        profileImage.sd_setImage(with: url, placeholderImage: .userAdd)
    }
    
    @objc private func didTouchLogInButton(_ sender: UIButton) {
        delegate?.didTapLogInButton()
    }
    
    @objc private func handleAuthStateChange(_ notification: Notification) {
        // Access authState directly from userInfo
        if let authState = notification.userInfo?["authState"] as? AuthenticationState {
            DispatchQueue.main.async { // Ensure this executes on the main thread
                switch authState {
                case .authenticated:
                    self.isLoggedIn = true
                case .unauthenticated:
                    self.isLoggedIn = false
                default:
                    break
                }
            }
        }
    }
}

extension MainSearchBarView: DynamicSearchBarDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        delegate?.searchFieldTextDidChange(textField.text)
    }
}
