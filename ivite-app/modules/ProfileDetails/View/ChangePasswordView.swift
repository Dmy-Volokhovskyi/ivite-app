//
//  ChangePasswordView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 01/11/2024.
//

import UIKit

final class ChangePasswordView: BaseView {
    private let titleLabel = UILabel()
    private let oldPasswordTextField = IVTextField(placeholder: "Old password", leadingImage: .email)
    private let newPasswordTextField = IVTextField(placeholder: "New password", leadingImage: .email)
    private let changePasswordButton = UIButton(configuration: .secondary(title: "Change Password"))
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 16
        backgroundColor = .dark10
        
        titleLabel.text = "Change password"
        titleLabel.font = .interFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .secondary1
        
        oldPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.isSecureTextEntry = true
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            titleLabel,
            oldPasswordTextField,
            newPasswordTextField,
            changePasswordButton
        ].forEach { addSubview($0) }
        
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        titleLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
        
        oldPasswordTextField.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 24)
        oldPasswordTextField.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        oldPasswordTextField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        newPasswordTextField.autoPinEdge(.top, to: .bottom, of: oldPasswordTextField, withOffset: 8)
        newPasswordTextField.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        newPasswordTextField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        changePasswordButton.autoPinEdge(.top, to: .bottom, of: newPasswordTextField, withOffset: 8)
        changePasswordButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        changePasswordButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        changePasswordButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 24)
    }
}
