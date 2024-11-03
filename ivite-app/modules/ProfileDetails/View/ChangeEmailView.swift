//
//  ChangeEmailView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 01/11/2024.
//

import UIKit

final class ChangeEmailView: BaseView {
    private let titleLabel = UILabel()
    private let changeEmailTextField = IVTextField(placeholder: "Change email", leadingImage: .email)
    private let confirmPasswordTextField = IVTextField(placeholder: "Confirm password", leadingImage: .email)
    private let changeEmailButton = UIButton(configuration: .secondary(title: "Change Email"))
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 16
        backgroundColor = .dark10

        titleLabel.font = .interFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .secondary1
        
        changeEmailTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            titleLabel,
            changeEmailTextField,
            confirmPasswordTextField,
            changeEmailButton
        ].forEach { addSubview($0) }
        
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        titleLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
        
        changeEmailTextField.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 24)
        changeEmailTextField.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        changeEmailTextField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        confirmPasswordTextField.autoPinEdge(.top, to: .bottom, of: changeEmailTextField, withOffset: 8)
        confirmPasswordTextField.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        confirmPasswordTextField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        changeEmailButton.autoPinEdge(.top, to: .bottom, of: confirmPasswordTextField, withOffset: 8)
        changeEmailButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        changeEmailButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        changeEmailButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 24)
    }
}
