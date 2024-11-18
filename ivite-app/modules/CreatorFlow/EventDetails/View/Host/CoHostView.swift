//
//  CoHostView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 12/10/2024.
//

import UIKit

protocol CoHostViewDelegate: AnyObject {
    func coHostView(_ view: CoHost)
}

final class CoHostView: BaseView {
    private let coHost: CoHost
    private let nameTextField: IVTextField
    private let menuButton = UIButton(configuration: .image(image: .menu))
    
    weak var delegate: CoHostViewDelegate?
    
    init(coHost: CoHost) {
        self.coHost = coHost
        self.nameTextField = IVTextField(text: coHost.name)
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            nameTextField,
            menuButton
        ].forEach({ addSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        nameTextField.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .trailing)
        nameTextField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameTextField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        menuButton.autoPinEdge(.leading, to: .trailing, of: nameTextField, withOffset: 12)
        menuButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .leading)
        menuButton.autoMatch(.width, to: .height, of: menuButton)
        
        menuButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        menuButton.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    @objc private func menuButtonTapped(_ sender: UIButton) {
        delegate?.coHostView(coHost)
    }
}
