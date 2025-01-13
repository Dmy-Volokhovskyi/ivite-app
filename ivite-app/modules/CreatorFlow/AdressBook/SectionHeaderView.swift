//
//  SectionHeaderViewDelegate.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 12/01/2025.
//


import UIKit

protocol SectionHeaderViewDelegate: AnyObject {
    func didTapSectionHeader(_ section: Int)
}

final class SectionHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "SectionHeaderView"

    private let titleLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let separatorView = UIView()
    
    weak var delegate: SectionHeaderViewDelegate?
    var section: Int = 0 // To track which section this header belongs to
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        addSubviews()
        constrainSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        
        // Title Label Styling
        titleLabel.font = .interFont(ofSize: 16, weight: .regular)
        titleLabel.textColor = .secondary1
        // Chevron Styling
        chevronImageView.image = .chevronDown
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.tintColor = UIColor.dark30
        
        // Separator Styling
        separatorView.backgroundColor = UIColor.dark20
        
        // Add tap gesture for interactivity
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        addGestureRecognizer(tapGesture)
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronImageView)
        contentView.addSubview(separatorView)
    }
    
    private func constrainSubviews() {
        titleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        titleLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        chevronImageView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        chevronImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        chevronImageView.autoSetDimensions(to: CGSize(width: 16, height: 16))
        
        separatorView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        separatorView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        separatorView.autoPinEdge(toSuperviewEdge: .bottom)
        separatorView.autoSetDimension(.height, toSize: 1)
    }
    
    func configure(with title: String, section: Int, isCollapsed: Bool) {
        self.titleLabel.text = title
        self.section = section
        self.chevronImageView.transform = isCollapsed ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: .pi)
    }
    
    @objc private func didTapHeader() {
        delegate?.didTapSectionHeader(section)
    }
}
