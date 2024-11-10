//
//  AddGuestsmenuItem.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 08/11/2024.
//

import UIKit

final class AddGuestsmenuItem: BaseControll {
    private let imageContainerView = UIView()
    private let imageView = UIImageView ()
    private let menuItemLabel = UILabel()
    
    init(menuItem: AddGuestMenu) {
        super.init(frame: .zero)
        
        imageView.image = menuItem.image
        
        menuItemLabel.text = menuItem.title
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   override func setupView() {
       super.setupView()
       
       backgroundColor = .dark10
       layer.cornerRadius = 14
       
       imageContainerView.layer.cornerRadius = 22
       imageContainerView.backgroundColor = .white
       
       menuItemLabel.textColor = .secondary1
       menuItemLabel.font = .interFont(ofSize: 14, weight: .semiBold)
       menuItemLabel.numberOfLines = 0
       menuItemLabel.textAlignment = .center
   }
    
   override func addSubviews() {
       super.addSubviews()
       
       addSubview(imageContainerView)
       
       imageContainerView.addSubview(imageView)
       
       addSubview(menuItemLabel)
   }
    
   override func constrainSubviews() {
       super.constrainSubviews()
       
       imageContainerView.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
       imageContainerView.autoAlignAxis(toSuperviewAxis: .vertical)
       
       imageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
       
       menuItemLabel.autoPinEdge(.top, to: .bottom, of: imageContainerView, withOffset: 12)
       menuItemLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16, relation: .greaterThanOrEqual)
       menuItemLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16, relation: .greaterThanOrEqual)
       menuItemLabel.autoAlignAxis(toSuperviewAxis: .vertical)
       menuItemLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
   }
}
