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

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()

    override func setupView() {
        backgroundColor = UIColor.white
    }

    override func addSubviews() {
        super.addSubviews()
        
        addSubview(stackView)

        for item in menuItems {
            let button = TextEditMenuButton(menuItem: item)
            button.addTarget(self, action: #selector(menuButtonTapped(_:)), for: .touchUpInside)
            button.tag = menuItems.firstIndex(of: item) ?? 0
            stackView.addArrangedSubview(button)
        }
    }

    override func constrainSubviews() {
        super.constrainSubviews()
        
        stackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        stackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        stackView.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        stackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
    }

    @objc private func menuButtonTapped(_ sender: UIButton) {
        let selectedItem = menuItems[sender.tag]
        delegate?.textEditMenu(self, didSelectItem: selectedItem)
    }
}
