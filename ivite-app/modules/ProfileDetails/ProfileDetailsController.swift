import UIKit

protocol ProfileDetailsEventHandler: AnyObject {
    func viewWillAppear()
    func didTouchChangeProfileImage()
    func didSelectNewProfileImage(_ image: UIImage)
    func didTouchDeleteAccount()
    func changeEmail(newEmail: String, confirmPassword: String)
    func changePassword(oldPassword: String, newPassword: String)
}

protocol ProfileDetailsDataSource: AnyObject {
    var user: IVUser? { get }
    var authProvider: AuthenticationProvider { get }
}

final class ProfileDetailsController: BaseScrollViewController {
    private let eventHandler: ProfileDetailsEventHandler
    private let dataSource: ProfileDetailsDataSource
    
    private let backButton = UIButton(configuration: .image(image: .chewroneBack))
    private let profileDetailsLabel = UILabel()
    private let contentStackView = UIStackView()
    private let mainDetailsContainer = UIView()
    private let profileImageView = UIImageView(image: .test)
    private let credentialsStackView = UIStackView()
    private let nameLabel = IVTextField(placeholder: "Your name", leadingImage: .person)
    private let emailLabel = IVTextField(placeholder: "Email address", leadingImage: .email)
    private let phoneLabel = IVTextField(placeholder: "Phone number", leadingImage: .phone)
    private let deleteAccountButton = UIButton(configuration: .secondary(title: "Delete account"))
    private let changePasswordView = ChangePasswordView()
    private let changeEmailView = ChangeEmailView()
    
    init(eventHandler: ProfileDetailsEventHandler, dataSource: ProfileDetailsDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 24
        
        profileDetailsLabel.text = "Profile details"
        profileDetailsLabel.font = .interFont(ofSize: 24, weight: .bold)
        profileDetailsLabel.textColor = .secondary1
        
        profileImageView.layer.cornerRadius = 56
        profileImageView.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
        
        credentialsStackView.axis = .vertical
        credentialsStackView.spacing = 8
        mainDetailsContainer.backgroundColor = .dark10
        mainDetailsContainer.layer.cornerRadius = 16
        
        changePasswordView.delegate = self
        changePasswordView.isHidden = dataSource.authProvider == .google
        
        changeEmailView.delegate = self
        changeEmailView.isHidden = dataSource.authProvider == .google
        
        backButton.addTarget(self, action: #selector(didTouchBack), for: .touchUpInside)
        deleteAccountButton.addTarget(self, action: #selector(didTouchDeleteAccount), for: .touchUpInside)
        view.backgroundColor = .white
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            backButton,
            profileDetailsLabel,
            contentStackView
        ].forEach({ contentView.addSubview($0) })
        
        [
            mainDetailsContainer,
            changePasswordView,
            changeEmailView
        ].forEach(contentStackView.addArrangedSubview)
        
        [
            profileImageView,
            credentialsStackView,
            deleteAccountButton
        ].forEach({ mainDetailsContainer.addSubview($0) })
        
        [
            nameLabel,
            emailLabel,
            phoneLabel
        ].forEach({ credentialsStackView.addArrangedSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        backButton.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        backButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        
        profileDetailsLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        profileDetailsLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        profileDetailsLabel.autoPinEdge(.leading, to: .trailing, of: backButton, withOffset: 16)
        profileDetailsLabel.autoAlignAxis(.horizontal, toSameAxisOf: backButton)
        
        contentStackView.autoPinEdge(.top, to: .bottom, of: profileDetailsLabel, withOffset: 24)
        contentStackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        contentStackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        contentStackView.autoPinEdge(toSuperviewEdge: .bottom)
        
        setUpmainDetailsContainerConstraints()
    }
    
    private func setUpmainDetailsContainerConstraints() {
        profileImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 24)
        profileImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16, relation: .greaterThanOrEqual)
        profileImageView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16, relation: .greaterThanOrEqual)
        profileImageView.autoAlignAxis(toSuperviewAxis: .vertical)
        profileImageView.autoSetDimensions(to: CGSize(width: 112, height: 112))
        
        credentialsStackView.autoPinEdge(.top, to: .bottom, of: profileImageView, withOffset: 24)
        credentialsStackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        credentialsStackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        deleteAccountButton.autoPinEdge(.top, to: .bottom, of: credentialsStackView, withOffset: 24)
        deleteAccountButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        deleteAccountButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        deleteAccountButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 24)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventHandler.viewWillAppear()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc private func didTouchBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTouchDeleteAccount(_ sender: UIButton) {
        eventHandler.didTouchDeleteAccount()
    }
    
    @objc private func didTapProfileImage() {
        eventHandler.didTouchChangeProfileImage()
    }
}

extension ProfileDetailsController: ProfileDetailsViewInterface {
    func clearPasswordChange() {
        changePasswordView.clear()
    }
    
    func update(_ user: IVUser) {
        let url = URL(string: user.profileImageURL ?? "")
        profileImageView.sd_setImage(with: url, placeholderImage: .userAdd)
        
        nameLabel.text = user.firstName
        emailLabel.text = user.email
    }
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
}

extension ProfileDetailsController: ChangePasswordViewDelegate {
    func changePassword(_ view: ChangePasswordView, oldPassword: String, newPassword: String) {
        eventHandler.changePassword(oldPassword: oldPassword, newPassword: newPassword)
    }
}

extension ProfileDetailsController: ChangeEmailViewDelegate {
    func changeEmail(_ view: ChangeEmailView, confirmPassword: String, newEmail: String) {
        eventHandler.changeEmail(newEmail: newEmail, confirmPassword: confirmPassword)
    }
}

extension ProfileDetailsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        
        eventHandler.didSelectNewProfileImage(selectedImage)
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
