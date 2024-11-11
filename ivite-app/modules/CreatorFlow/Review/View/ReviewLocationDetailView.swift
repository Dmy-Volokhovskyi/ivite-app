//
//  ReviewLocationDetail.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/11/2024.
//

import UIKit

final class ReviewLocationDetailView: BaseView {
    private let stackView = UIStackView()
    private let locationTitledView = ReviewTitledView()
    private let firstDividerView = DividerView(topSpace: 8, bottomSpace: .zero)
    private let noteTitledView = ReviewTitledView()
    private let secondDividerView = DividerView(topSpace: 8, bottomSpace: .zero)
    private let bringListTitledView = ReviewTitledView()
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 10
        backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.spacing = 16
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(stackView)
        
        [
            locationTitledView,
            firstDividerView,
            noteTitledView,
            secondDividerView,
            bringListTitledView
        ].forEach { stackView.addArrangedSubview($0) }
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    public func configure(model: EventDetailsViewModel) {
        if let location = model.location {
            locationTitledView.configure(title: "Location", subtitle: location, content: nil)
        }
        
        if let note = model.note {
            noteTitledView.isHidden = false
            firstDividerView.isHidden = false
            noteTitledView.configure(title: "Note", subtitle: note, content: nil)
        } else {
            noteTitledView.isHidden = true
            firstDividerView.isHidden = true
        }
        
        if !model.bringList.isEmpty {
            bringListTitledView.isHidden = false
            secondDividerView.isHidden = false
            let subtitle = formatBringList(items: model.bringList)
            bringListTitledView.configure(title: "Bring List", subtitle: subtitle, content: nil)
        } else {
            bringListTitledView.isHidden = true
            secondDividerView.isHidden = true
        }
        
    }
    
    private func formatBringList(items: [BringListItem]) -> String {
        return items
            .compactMap { item in
                guard let name = item.name, let count = item.count else { return nil }
                return "\(name) | \(count)x"
            }
            .joined(separator: "\n")
    }
}
