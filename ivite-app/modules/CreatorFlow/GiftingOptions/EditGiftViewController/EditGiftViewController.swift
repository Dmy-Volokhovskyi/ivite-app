//
//  EditGiftViewController.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 08/11/2024.
//

import UIKit

protocol EditGiftViewControllerDeltgate: AnyObject {
    func didEdditGift(_ gift: Gift)
}

final class EditGiftViewController: BaseViewController {
    private let photoLibraryManager: PhotoLibraryManager
    
    private let addGiftTitleLabel = IVHeaderLabel(text: "Gift edit")
    private let giftTitleTextFiel = IVTextField(placeholder: "Gift title")
    private let addGiftRegistryEntry = EntryWithTitleView(title: "Add Gift Registry")
    private let linkTextField = IVTextField(placeholder: "Link to the gift (optional)", leadingImage: .link)
    private let addGiftRegistryLabel = UILabel()
    private let saveButton = UIButton(configuration: .secondary(title: "Save"))
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
        
        view.backgroundColor = .white
        
        addGiftRegistryEntry.setContentView(giftTitleTextFiel)
        
        addGiftRegistryLabel.textColor = .secondary1
        addGiftRegistryLabel.font = .interFont(ofSize: 16, weight: .regular)
        
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
        ].forEach({ view.addSubview($0) } )
        
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
        
        saveButton.autoPinEdge(.top, to: .bottom, of: addImageView, withOffset: 16)
        saveButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        saveButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        saveButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
    }
    
    @objc private func didTouchSave(_ sender: UIButton) {
        let gift = Gift(name: giftTitleTextFiel.text ?? "''", link: linkTextField.text, image: addImageView.getImageData())
        
        giftTitleTextFiel.text = nil
        linkTextField.text = nil
        addImageView.displayImage(nil)
        
        delegate?.didAddGift(gift)
    }
}
