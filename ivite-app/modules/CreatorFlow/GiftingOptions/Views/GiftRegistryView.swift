//
//  GiftRegistryViewDelegate.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 03/11/2024.
//


import UIKit
import PureLayout

protocol GiftRegistryViewDelegate: AnyObject {
    func giftRegistryViewDidRequestPhotoLibraryAccess(_ view: GiftRegistryView)
    func giftRegistryViewDidRequestDeleteImage(_ view: GiftRegistryView)
}

class GiftRegistryView: BaseControll {
    
    weak var delegate: GiftRegistryViewDelegate?
    
    private let imageView = UIImageView()
    private let placeholderImageViewContainer = UIView()
    private let placeholderImageView = UIImageView(image: UIImage(resource: .imageGallery80))
    private let addImageLabel = UILabel()
    private let repickButton = UIButton(configuration: .image(image: .reuse))
    private let deleteButton = UIButton(configuration: .image(image: .orangeTrash))
    
    override func setupView() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        clipsToBounds = true
        
        // Configure addImageLabel directly
        addImageLabel.text = "Add image"
        addImageLabel.font = .interFont(ofSize: 16, weight: .regular)
        addImageLabel.textColor = .dark30
        addImageLabel.textAlignment = .center
        
        repickButton.isHidden = true
        deleteButton.isHidden = true
        
        self.addTarget(self, action: #selector(requestPhotoLibraryAccess), for: .touchUpInside)
        repickButton.addTarget(self, action: #selector(requestPhotoLibraryAccess), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTouchDeleteButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        [
            placeholderImageViewContainer,
            imageView,
            repickButton,
            deleteButton
        ].forEach { addSubview($0) }
        
        placeholderImageViewContainer.addSubview(placeholderImageView)
        placeholderImageViewContainer.addSubview(addImageLabel)
    }
    
    override func constrainSubviews() {
        self.autoMatch(.height, to: .width, of: self, withMultiplier: 280 / 343)
        
        imageView.autoPinEdgesToSuperviewEdges()
        
        placeholderImageViewContainer.autoCenterInSuperview()
        
        deleteButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        deleteButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 18)
        
        repickButton.autoPinEdge(.trailing, to: .leading, of: deleteButton, withOffset: -4)
        repickButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 18)
        
        constrainPlaceholderImageViewContainer()
    }
    
    private func constrainPlaceholderImageViewContainer() {
        placeholderImageView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        addImageLabel.autoPinEdge(.top, to: .bottom, of: placeholderImageView, withOffset: 12)
        addImageLabel.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    public func displayImage(_ image: UIImage?) {
        imageView.image = image
        imageView.isHidden = image == nil
        repickButton.isHidden = image == nil
        deleteButton.isHidden = image == nil
    }
    
    public func getImageData() -> Data? {
        imageView.image?.pngData()
    }
    
    @objc private func didTouchDeleteButton(_ sender: UIButton) {
        delegate?.giftRegistryViewDidRequestDeleteImage(self)
    }
    
    @objc private func requestPhotoLibraryAccess(_ sender: UIControl) {
        delegate?.giftRegistryViewDidRequestPhotoLibraryAccess(self)
    }
}
