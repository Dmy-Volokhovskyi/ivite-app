//
//  AddGiftView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 04/11/2024.
//

import UIKit

protocol AddGiftViewDelegate: AnyObject {
    func didAddGift(_ gift: Gift)
}

final class AddGiftView: BaseView {
    private let photoLibraryManager: PhotoLibraryManager
    
    private let addGiftTitleLabel = IVHeaderLabel(text: "Add Gift")
    private let giftTitleTextFiel = IVTextField(placeholder: "Gift title")
    private let addGiftRegistryEntry = EntryWithTitleView(title: "Add Gift Registry")
    private let linkTextField = IVTextField(placeholder: "Link to the gift (optional)", leadingImage: .link)
    private let addGiftRegistryLabel = UILabel()
    private let addGiftButton = UIButton(configuration: .secondary(title: "Add"))
    private let addImageView: GiftRegistryView
    
    weak var delegate: AddGiftViewDelegate?
    
    init(photoLibraryManager: PhotoLibraryManager,
                  addImageView: GiftRegistryView) {
        self.photoLibraryManager = photoLibraryManager
        self.addImageView = addImageView
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        addGiftRegistryEntry.setContentView(giftTitleTextFiel)
        giftTitleTextFiel.delegate = self
        
        addGiftRegistryLabel.textColor = .secondary1
        addGiftRegistryLabel.font = .interFont(ofSize: 16, weight: .regular)
        
        addGiftButton.addTarget(self, action: #selector(didTouchAddGift), for: .touchUpInside)
        addGiftButton.IVsetEnabled(false, title: "Add")
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            addGiftTitleLabel,
            addGiftRegistryEntry,
            linkTextField,
            addGiftRegistryLabel,
            addImageView,
            addGiftButton,
        ].forEach({ addSubview($0) } )
        
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        addGiftTitleLabel.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16), excludingEdge: .bottom)
        
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
        
        addGiftButton.autoPinEdge(.top, to: .bottom, of: addImageView, withOffset: 16)
        addGiftButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        addGiftButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        addGiftButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
    }
    
    @objc private func didTouchAddGift(_ sender: UIButton) {
        let gift = Gift(name: giftTitleTextFiel.text ?? "''", link: linkTextField.text, image: addImageView.getImageData(), gifterId: nil)
        
        giftTitleTextFiel.text = nil
        linkTextField.text = nil
        addImageView.displayImage(nil)
        addGiftButton.IVsetEnabled(false, title: "Add")
        
        delegate?.didAddGift(gift)
    }
}

extension AddGiftView: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        let isEnabled = textField.text?.isEmpty == false
        addGiftButton.IVsetEnabled(isEnabled, title: "Add")
    }
}
