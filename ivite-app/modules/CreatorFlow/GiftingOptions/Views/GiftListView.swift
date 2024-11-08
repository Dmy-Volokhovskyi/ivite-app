//
//  GiftsListView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 04/11/2024.
//

import UIKit

protocol GiftListViewDelegate: AnyObject {
    func didTouchMenuButton(for gift: Gift)
}

final class GiftListView: BaseView {
    private let giftListLabel = IVHeaderLabel(text: "Gift list")
    private let giftsStackView = UIStackView()
    
    var gifts: [Gift]
    
    weak var delegate: GiftListViewDelegate?
    
    init(gifts: [Gift]) {
        self.gifts = gifts
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupView() {
        super.setupView()
        
        giftsStackView.axis = .vertical
        giftsStackView.spacing = 12
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(giftListLabel)
        addSubview(giftsStackView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        giftListLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16), excludingEdge: .bottom)
        
        giftsStackView.autoPinEdge(.top, to: .bottom, of: giftListLabel, withOffset: 16)
        giftsStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), excludingEdge: .top)
    }
    
    private func fillStack(gifts: [Gift]) {
        giftsStackView.subviews.forEach({ $0.removeFromSuperview() })
        
        gifts.forEach { gift in
            let giftView = GiftView(gift: gift)
            giftView.delegate = self
            giftsStackView.addArrangedSubview(giftView)
        }
    }
    
    public func updateGifts(gifts: [Gift]) {
        self.gifts = gifts
        fillStack(gifts: gifts)
    }
}

extension GiftListView: GiftViewDelegate {
    func didTouchMenuButton(for gift: Gift) {
        delegate?.didTouchMenuButton(for: gift)
    }
}
