//
//  EntryWithTitle.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 11/10/2024.
//

import UIKit

final class EntryWithTitleView: BaseView {
    private let titleLabel = UILabel()
    private let requiredLabel = UILabel()
    private let contentView = UIView()
    private let isRequired: Bool = false
    
    init(title: String, isRequired: Bool = false) {
        super.init(frame: .zero)
        self.setTitle(title)
        requiredLabel.isHidden = !isRequired
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        titleLabel.textColor = .secondary1
        titleLabel.font = .interFont(ofSize: 16, weight: .regular)
        
        requiredLabel.textColor = .secondary70
        requiredLabel.font = .interFont(ofSize: 14)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.18
        requiredLabel.attributedText = NSMutableAttributedString(string: "(Required)",
                                                                 attributes: [NSAttributedString.Key.kern: -0.42, NSAttributedString.Key.paragraphStyle: paragraphStyle])

    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            titleLabel,
            requiredLabel,
            contentView
        ].forEach({ addSubview ($0)})
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        titleLabel.autoPinEdge(toSuperviewEdge: .top)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading)
        
        requiredLabel.autoPinEdge(.leading, to: .trailing, of: titleLabel, withOffset: 4)
        requiredLabel.autoAlignAxis(.horizontal, toSameAxisOf: titleLabel)
        
        contentView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 4)
        contentView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        
    }
    
    public func setTitle(_ title: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.24
        titleLabel.attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.kern: -0.48, NSAttributedString.Key.paragraphStyle: paragraphStyle])

    }
    
    public func setContentView(_ contentView: UIView) {
        self.contentView.addSubview(contentView)
        contentView.autoPinEdgesToSuperviewEdges()
    }
}
