//
//  ChangeEmailView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 01/11/2024.
//

import UIKit

protocol ChangeEmailViewDelegate: AnyObject {
    func changeEmail(_ view: ChangeEmailView, confirmPassword: String, newEmail: String)
}

final class ChangeEmailView: BaseView {
    private let titleLabel = UILabel()
    private let changeEmailTextField = IVTextField(placeholder: "Change email", leadingImage: .email, validationType: .email)
    private let confirmPasswordTextField = IVTextField(placeholder: "Confirm password", leadingImage: .password)
    private let changeEmailButton = UIButton(configuration: .secondary(title: "Change Email"))
    
    weak var delegate: ChangeEmailViewDelegate?
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 16
        backgroundColor = .dark10
        
        titleLabel.text = "Email Addresses"
        titleLabel.font = .interFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .secondary1
        
        changeEmailTextField.delegate = self
        
        confirmPasswordTextField.secured = true
        confirmPasswordTextField.delegate = self
        
        changeEmailButton.IVsetEnabled(false, title: "Change Email")
        changeEmailButton.addTarget(self, action: #selector(changeEmailButtonTapped), for: .touchUpInside)
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
    
    @objc private func changeEmailButtonTapped(_ sender: UIButton) {
        guard let newEmail = changeEmailTextField.text,
              let confirmPassword = confirmPasswordTextField.text else { return }
        delegate?.changeEmail(self, confirmPassword: confirmPassword, newEmail: newEmail)
    }
}

extension ChangeEmailView: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        guard let newEmail = changeEmailTextField.text,
              let confirmPassword = confirmPasswordTextField.text else { return }
        
        let readyToChangeEmail = newEmail.isEmpty == false &&
        confirmPassword.isEmpty == false
        
        changeEmailButton.IVsetEnabled(readyToChangeEmail, title: "Change Password")
    }
}
