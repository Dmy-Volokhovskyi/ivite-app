//
//  IVControl.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 11/10/2024.
//

import UIKit
import PureLayout

protocol IVControlDelegate: AnyObject {
    func didTouchDisabledTextField(_ control: IVControl)
}

final class IVControl: BaseControll {
    private var placeholder: String = ""
    private let textField = UITextField()
    weak var delegate: IVControlDelegate?

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    // Initializer
    init(text: String = "", placeholder: String = "") {
        self.placeholder = placeholder
        textField.text = text
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 22
        backgroundColor = .dark10 // Initial background color
        self.isUserInteractionEnabled = true
        
        textField.isUserInteractionEnabled = false
        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)

        // Add highlight when pressed
        self.addTarget(self, action: #selector(didTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(didTouchUp), for: [.touchUpInside, .touchUpOutside])
        
        textField.placeholder = placeholder
        textField.borderStyle = .none
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(textField)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        textField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20))
    }

    // Change background color when pressed
    @objc private func didTouchDown() {
        backgroundColor = .red // Highlight when clicked
    }

    // Revert background color when released and notify delegate
    @objc private func didTouchUp() {
        backgroundColor = .dark10 // Revert to original color
        delegate?.didTouchDisabledTextField(self)
    }

    // Notify delegate on touch up inside
    @objc private func didTouchUpInside() {
        delegate?.didTouchDisabledTextField(self)
    }
}

