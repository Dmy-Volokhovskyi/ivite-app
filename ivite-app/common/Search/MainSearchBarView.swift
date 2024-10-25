//
//  MainSearchBarView.swift
//  ivite-app
//
//  Created by GoApps Developer on 04/09/2024.
//

import UIKit

protocol MainSearchBarViewDelegate: AnyObject {
    func didTapLogInButton()
}

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
    
    init(isLoggedIn: Bool = false) {
        self.isLoggedIn = isLoggedIn
        super.init()
        
        logInButton.isHidden = isLoggedIn
        profileImage.isHidden = !isLoggedIn
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
    
    @objc private func didTouchLogInButton(_ sender: UIButton) {
        delegate?.didTapLogInButton()
    }
}
