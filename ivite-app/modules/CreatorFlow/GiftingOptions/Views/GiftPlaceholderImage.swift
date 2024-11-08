//
//  GiftPlaceholderImage.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 04/11/2024.
//

import UIKit

class GiftPlaceholderImage: BaseView {
    private let imageView = UIImageView()
    private let placeholderImageView = UIImageView(image: UIImage(resource: .imageGallery24))

    
    override func setupView() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 3
        clipsToBounds = true
    }
    
    override func addSubviews() {
        [
            placeholderImageView,
            imageView
        ].forEach { addSubview($0) }
    }
    
    override func constrainSubviews() {
        imageView.autoPinEdgesToSuperviewEdges()
        
        placeholderImageView.autoCenterInSuperview()
    }
    
    public func displayImage(_ imageData: Data?) {
        if let imageData {
            imageView.image = UIImage(data: imageData)
        }
        imageView.isHidden = imageData == nil
    }
    
    public func getImageData() -> Data? {
        imageView.image?.pngData()
    }
}
