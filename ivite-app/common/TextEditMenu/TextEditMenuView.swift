//
//  TextEditMenuView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 24/09/2024.
//

import UIKit

protocol TextEditMenuDelegate: AnyObject {
    func textEditMenu(_ menu: TextEditMenuView, didSelectItem item: TextEditMenuItem)
}

class TextEditMenuView: BaseView {
    weak var delegate: TextEditMenuDelegate?
    
    let menuItems: [TextEditMenuItem] = [.editText, .font, .size, .color, .format, .spacing]
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing // Spread items equally with spacing
        stackView.alignment = .center
        stackView.spacing = 16 // Adjust as needed for additional spacing
        return stackView
    }()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        for item in menuItems {
            let button = TextEditMenuButton(menuItem: item)
            button.addTarget(self, action: #selector(menuButtonTapped(_:)), for: .touchUpInside)
            button.tag = menuItems.firstIndex(of: item) ?? 0
            stackView.addArrangedSubview(button)
        }
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        scrollView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 4, left: 16, bottom: 16, right: 16))
        stackView.autoPinEdgesToSuperviewEdges(with: .zero)
        stackView.autoMatch(.height, to: .height, of: scrollView)
        stackView.autoMatch(.width, to: .width, of: scrollView, withOffset: 0, relation: .greaterThanOrEqual)
    }
    
    @objc private func menuButtonTapped(_ sender: UIButton) {
        let selectedItem = menuItems[sender.tag]
        delegate?.textEditMenu(self, didSelectItem: selectedItem)
    }
}

