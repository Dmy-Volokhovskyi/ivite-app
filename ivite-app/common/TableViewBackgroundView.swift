//
//  TableViewBackgroundView.swift
//  ivite-app
//
//  Created by GoApps Developer on 06/09/2024.
//

import UIKit

final class TableViewBackgroundView: BaseView {
    private let imageView = UIImageView(image: .emptyBox)
    private let messageLabel = UILabel()
    
   override func setupView() {
       super.setupView()
       
       messageLabel.font = .interFont(ofSize: 16, weight: .regular)
       messageLabel.textColor = .secondary70
   }
    
   override func addSubviews() {
       super.addSubviews()
       
       addSubview(imageView)
       addSubview(messageLabel)
   }
    
   override func constrainSubviews() {
       super.constrainSubviews()
       
       imageView.autoPinEdge(toSuperviewEdge: .top, withInset: 122)
       imageView.autoAlignAxis(toSuperviewAxis: .vertical)
       imageView.autoMatch(.height, to: .width, of: imageView)
       
       messageLabel.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: 20)
       messageLabel.autoAlignAxis(toSuperviewAxis: .vertical)
   }
    
    func configure(text: String, image: UIImage? = .emptyBox) {
        messageLabel.text = text
        imageView.image = image
    }
}
