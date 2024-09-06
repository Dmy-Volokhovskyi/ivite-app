//
//  MainSearchBarView.swift
//  ivite-app
//
//  Created by GoApps Developer on 04/09/2024.
//

import UIKit

final class MainSearchBarView: BaseView {
    private let stackView = UIStackView()
    private let logoImage = UIImageView(image: .logo)
    private let searchButton = DynamicSearchBar()
    private let profileImage = UIImageView(image: .test)
    
    override func setupView() {
        super.setupView()
        
        stackView.spacing = 12
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(stackView)
        
        [
            logoImage,
            searchButton,
            profileImage
        ].forEach({ stackView.addArrangedSubview($0) })
    }
    
   override func constrainSubviews() {
       super.constrainSubviews()
       
       logoImage.autoSetDimensions(to: CGSize(width: 44, height: 44))
       
       profileImage.autoSetDimensions(to: CGSize(width: 44, height: 44))
       
       stackView.autoPinEdgesToSuperviewEdges()
   }
}
