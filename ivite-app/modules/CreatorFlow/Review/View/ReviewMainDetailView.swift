//
//  ReviewMainDetailView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 10/11/2024.
//

import UIKit

final class ReviewMainDetailView: BaseView {
    private let editButton = UIButton(configuration: .plain())
    private let eventTitleLabel = IVHeaderLabel()
    private let timeAndDateView = ReviewTitledView()
    private let timezoneLabel = UILabel()
    private let dividerView = DividerView()
    
    private let hostStackView = UIStackView()
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 10
        backgroundColor = .white
        
        hostStackView.axis = .vertical
        hostStackView.spacing = 16
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            eventTitleLabel,
            timeAndDateView,
            timezoneLabel,
            dividerView,
            hostStackView
        ].forEach(addSubview)
        
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        eventTitleLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), excludingEdge: .bottom)
        
        timeAndDateView.autoPinEdge(.top, to: .bottom, of: eventTitleLabel, withOffset: 16)
        timeAndDateView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        timeAndDateView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        timezoneLabel.autoPinEdge(.top, to: .bottom, of: timeAndDateView)
        timezoneLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        timezoneLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        dividerView.autoPinEdge(.top, to: .bottom, of: timezoneLabel, withOffset: 24)
        dividerView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        dividerView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        hostStackView.autoPinEdge(.top, to: .bottom, of: dividerView, withOffset: 24)
        hostStackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        hostStackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        hostStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
    }
    
    private func fillHostViews(hostName: String?, coHosts: [CoHost]) {
        hostStackView.subviews.forEach({ $0.removeFromSuperview() })
        let hostedBy = ReviewTitledView()
        hostedBy.configure(title: "Hosted by", subtitle: hostName, content: nil)
        hostStackView.addArrangedSubview(hostedBy)
        let cohostedBy = ReviewTitledView()
        let coHostStackView = UIStackView()
        coHostStackView.axis = .vertical
        coHosts.forEach { coHost in
            let coHostedLabel = UILabel()
            coHostedLabel.text = coHost.name
            coHostedLabel.textColor = .secondary1
            coHostedLabel.font = .interFont(ofSize: 16, weight: .regular)
            coHostStackView.addArrangedSubview(coHostedLabel)
        }
        
        cohostedBy.configure(title: "Co-hosted by", subtitle: nil, content: coHostStackView)
        hostStackView.addArrangedSubview(cohostedBy)
    }
    
    public func configure(model: EventDetailsViewModel) {
        eventTitleLabel.text = model.eventTitle
        timeAndDateView.configure(title: "Time and date", subtitle: model.formattedDate(), content: nil)
        fillHostViews(hostName: model.hostName, coHosts: model.coHosts)
    }
}
