//
//  PreviewLocationDetailView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/12/2024.
//


import UIKit

final class PreviewLocationDetailView: BaseView {
    private let stackView = UIStackView()
    private let locationTitledView = PreviewTitledView()
    private let noteTitledView = PreviewTitledView()
    private let bringListTitledView = PreviewTitledView()
    
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
            noteTitledView,
            bringListTitledView
        ].forEach { stackView.addArrangedSubview($0) }
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
    }
    
    public func configure(model: EventDetailsViewModel) {
        if let location = model.location {
            locationTitledView.configure(title: "Location", subtitle: location, content: nil)
        }
        locationTitledView.isHidden = model.location == nil
        
        if let note = model.note {
            noteTitledView.isHidden = false
            noteTitledView.configure(title: "Note", subtitle: note, content: nil)
        } else {
            noteTitledView.isHidden = true
        }
        
        if !model.bringList.isEmpty {
            bringListTitledView.isHidden = false
            
            let bringListStackView = createBringListStackView(bringList: model.bringList)
            
            bringListTitledView.configure(title: "Bring List", subtitle: nil, content: bringListStackView)
        } else {
            bringListTitledView.isHidden = true
        }
        
    }
    
    func createBringListStackView(bringList: [BringListItem]) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for item in bringList {
            let bringItemView = PreviewBringItemView()
            bringItemView.configure(bringListItem: item)
            stackView.addArrangedSubview(bringItemView)
        }
        
        return stackView
    }
}
