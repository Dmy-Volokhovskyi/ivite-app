//
//  EditGiftViewController.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 08/11/2024.
//

import UIKit

protocol EditGiftViewDelegate: AnyObject {
    func didEdditGift(_ gift: Gift)
    func giftRegistryViewDidRequestPhotoLibraryAccess(_ view: GiftRegistryView)
}

final class EditGiftView: BaseView{
    private let photoLibraryManager = PhotoLibraryManager()
    
    private let addGiftTitleLabel = IVHeaderLabel(text: "Gift edit")
    private let giftTitleTextFiel = IVTextField(placeholder: "Gift title")
    private let addGiftRegistryEntry = EntryWithTitleView(title: "Add Gift Registry")
    private let linkTextField = IVTextField(placeholder: "Link to the gift (optional)", leadingImage: .link)
    private let addGiftRegistryLabel = UILabel()
    private let saveButton = UIButton(configuration: .primary(title: "Save"))
    private let addImageView = GiftRegistryView()
    private let gift: Gift
    
    weak var delegate: EditGiftViewDelegate?
    
    init(gift: Gift) {
        self.gift = gift
        super.init()
        
        giftTitleTextFiel.text = gift.name
        linkTextField.text = gift.link
        if let imageData = gift.image, let image = UIImage(data: imageData) {
            addImageView.displayImage(image)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        addGiftRegistryEntry.setContentView(giftTitleTextFiel)
        
        addGiftRegistryLabel.textColor = .secondary1
        addGiftRegistryLabel.font = .interFont(ofSize: 16, weight: .regular)
        giftTitleTextFiel.delegate = self
        
        addImageView.delegate = self
        
        saveButton.addTarget(self, action: #selector(didTouchSave), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            addGiftTitleLabel,
            addGiftRegistryEntry,
            linkTextField,
            addGiftRegistryLabel,
            addImageView,
            saveButton,
        ].forEach({ addSubview($0) } )
        
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        addGiftTitleLabel.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16), excludingEdge: .bottom)
        addGiftTitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addGiftTitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        addGiftRegistryEntry.autoPinEdge(.top, to: .bottom, of: addGiftTitleLabel, withOffset: 16)
        addGiftRegistryEntry.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        addGiftRegistryEntry.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        linkTextField.autoPinEdge(.top, to: .bottom, of: addGiftRegistryEntry, withOffset: 6)
        linkTextField.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        linkTextField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        addGiftRegistryLabel.autoPinEdge(.top, to: .bottom, of: linkTextField, withOffset: 12)
        addGiftRegistryLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        addGiftRegistryLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        addImageView.autoPinEdge(.top, to: .bottom, of: addGiftRegistryLabel, withOffset: 8)
        addImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        addImageView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        addImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        saveButton.autoPinEdge(.top, to: .bottom, of: addImageView, withOffset: 16)
        saveButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        saveButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        saveButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
    }
    
    @objc private func didTouchSave(_ sender: UIButton) {
        gift.name = giftTitleTextFiel.text ?? "''"
                        
        gift.link = linkTextField.text
                        
        gift.image = addImageView.getImageData()
        
        delegate?.didEdditGift(gift)
    }
}

extension EditGiftView: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        let isEnabled = textField.text?.isEmpty == false
        saveButton.IVsetEnabled(isEnabled, title: "Save")
    }
}

extension EditGiftView: GiftRegistryViewDelegate {
    func giftRegistryViewDidRequestPhotoLibraryAccess(_ view: GiftRegistryView) {
        delegate?.giftRegistryViewDidRequestPhotoLibraryAccess(view)
        print("Request photo library access")
    }
    
    func giftRegistryViewDidRequestDeleteImage(_ view: GiftRegistryView) {
        gift.image = nil
        addImageView.displayImage(nil)
    }
}
