//
//  ProfileDetailView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 28/10/2024.
//

import UIKit
import PureLayout

protocol ProfileViewDelegate: AnyObject {
    func didTouchShowProfile()
}

final class ProfileDetailView: BaseControll {
    private let profileImageView = UIImageView()
    private let labelsStackView = UIStackView()
    private let firstNamelabel = UILabel()
    private let showProfilLabel = UILabel()
    private let chevroneRightImageView = UIImageView(image: .chevroneRight)
    private var user: IVUser
    
    weak var delegate: ProfileViewDelegate?
    
    // Initializer
    init(user: IVUser) {
        self.user = user
        super.init(frame: .zero)
        firstNamelabel.text = user.firstName
        profileImageView.image = user.prifileImage
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup the view with a border radius of 1
    override func setupView() {
        super.setupView()
        
        labelsStackView.axis = .vertical
        
        profileImageView.layer.cornerRadius = 33.5
        profileImageView.clipsToBounds = true
        
        firstNamelabel.textColor = .secondary1
        firstNamelabel.font = .interFont(ofSize: 14)
        
        showProfilLabel.text = "Show profile"
        showProfilLabel.textColor = .dark30
        showProfilLabel.font = .interFont(ofSize: 16)
        
        backgroundColor = .white
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            profileImageView,
            labelsStackView,
            chevroneRightImageView
        ].forEach(addSubview)
        
        [
            firstNamelabel,
            showProfilLabel
        ].forEach({ labelsStackView.addArrangedSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        profileImageView.autoPinEdge(toSuperviewEdge: .top)
        profileImageView.autoPinEdge(toSuperviewEdge: .leading)
        profileImageView.autoPinEdge(toSuperviewEdge: .bottom)
        
        profileImageView.autoMatch(.height, to: .width, of: profileImageView)
        profileImageView.autoSetDimension(.width, toSize: 67)
        
        labelsStackView.autoPinEdge(.leading, to: .trailing, of: profileImageView, withOffset: 24)
        labelsStackView.autoAlignAxis(toSuperviewAxis: .horizontal)
        labelsStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        labelsStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        chevroneRightImageView.autoPinEdge(.leading, to: .trailing, of: labelsStackView)
        chevroneRightImageView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        chevroneRightImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        chevroneRightImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        chevroneRightImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    @objc private func didTouchShowProfile(_ sender: UIControl) {
        delegate?.didTouchShowProfile()
    }
}
