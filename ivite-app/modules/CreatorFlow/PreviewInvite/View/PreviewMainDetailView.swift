//
//  PreviewMainDetailView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 10/12/2024.
//

import UIKit

final class PreviewMainDetailView: BaseView {
    private let eventTitleLabel = UILabel()
    private let timeAndDateBackgroundView = UIView()
    private let timeAndDateView = ReviewTitledView()
    private let timezoneLabel = UILabel()
    
    private let hostStackView = UIStackView()
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 10
        backgroundColor = .white
        
        timeAndDateBackgroundView.layer.backgroundColor = UIColor.dark10.cgColor
        timeAndDateBackgroundView.layer.cornerRadius = 18
        
        eventTitleLabel.textAlignment = .center
        eventTitleLabel.font = .interFont(ofSize: 32, weight: .semiBold)
        eventTitleLabel.textColor = .secondary1
        
        timezoneLabel.textAlignment = .center
        timezoneLabel.font = .interFont(ofSize: 14, weight: .regular)
        timezoneLabel.textColor = .secondary70
        
        hostStackView.axis = .vertical
        hostStackView.spacing = 16
    }
    
    override func addSubviews() {
        super.addSubviews()
      
        [
            timeAndDateView,
            timezoneLabel
        ].forEach(timeAndDateBackgroundView.addSubview)
        
        [
            eventTitleLabel,
            timeAndDateBackgroundView,
            hostStackView
        ].forEach(addSubview)
        
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        eventTitleLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16), excludingEdge: .bottom)
        
        timeAndDateBackgroundView.autoPinEdge(.top, to: .bottom, of: eventTitleLabel, withOffset: 16)
        timeAndDateBackgroundView.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        timeAndDateBackgroundView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        
        timeAndDateView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), excludingEdge: .bottom)
        
        timezoneLabel.autoPinEdge(.top, to: .bottom, of: timeAndDateView, withOffset: 4)
        timezoneLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), excludingEdge: .top)
        
        hostStackView.autoPinEdge(.top, to: .bottom, of: timeAndDateBackgroundView, withOffset: 16)
        hostStackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        hostStackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        hostStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
    }
    
    private func fillHostViews(hostName: String?, coHosts: [CoHost]) {
        hostStackView.subviews.forEach({ $0.removeFromSuperview() })
        let hostedBy = PreviewTitledView()
        hostedBy.configure(title: "Hosted by", subtitle: hostName, content: nil)
        hostStackView.addArrangedSubview(hostedBy)
        let cohostedBy = PreviewTitledView()
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
        timeAndDateView.configure(title: "Time and date", subtitle: model.reviewFormattedDate(), content: nil)
        timezoneLabel.text = model.reviewFormattedTimezone()
        fillHostViews(hostName: model.hostName, coHosts: model.coHosts)
    }
}
