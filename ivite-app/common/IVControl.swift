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
    private let contentStackView = UIStackView()
    private var leadingImageView = UIImageView()
    private var trailingImageView = UIImageView()
    weak var delegate: IVControlDelegate?
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    init(text: String = "",
         placeholder: String = "",
         leadingImage: UIImage? = nil,
         trailingImage: UIImage? = nil) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        
        leadingImageView.image = leadingImage?.withTintColor(.dark30, renderingMode: .alwaysOriginal)
        leadingImageView.isHidden = leadingImage == nil
        
        trailingImageView.image = trailingImage?.withTintColor(.dark30, renderingMode: .alwaysOriginal)
        trailingImageView.isHidden = trailingImage == nil
        
        textField.text = text
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 22
        backgroundColor = .dark10
        self.isUserInteractionEnabled = true
        
        textField.isUserInteractionEnabled = false
        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
        self.addTarget(self, action: #selector(didTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(didTouchUp), for: [.touchUpInside, .touchUpOutside])
        
        contentStackView.axis = .horizontal
        contentStackView.spacing = 12
        contentStackView.isUserInteractionEnabled = false
        
        textField.placeholder = placeholder
        textField.borderStyle = .none
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [leadingImageView, textField, trailingImageView].forEach { contentStackView.addArrangedSubview($0) }
        addSubview(contentStackView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        contentStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20))
        leadingImageView.autoSetDimensions(to: CGSize(width: 20, height: 20))
        trailingImageView.autoSetDimensions(to: CGSize(width: 20, height: 20))
    }
    
    public func setTrailingImageView(image: UIImage?) {
        trailingImageView.image = image?.withTintColor(.dark30, renderingMode: .alwaysOriginal)
        trailingImageView.isHidden = image == nil
    }
    
    @objc private func didTouchDown() {
        backgroundColor = .dark20
    }
    
    @objc private func didTouchUp() {
        backgroundColor = .dark10
//        delegate?.didTouchDisabledTextField(self)
    }
    
    @objc private func didTouchUpInside() {
        delegate?.didTouchDisabledTextField(self)
    }
}


