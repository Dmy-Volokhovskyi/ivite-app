//
//  PreviewGiftsDetailView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 11/12/2024.
//


import UIKit

protocol PreviewGiftsDetailViewDelegate: AnyObject {
    func previewGiftViewDidTapLinkButton(_ gift: Gift)
    func previewGiftViewDidTapBringButton(_ gift: Gift)
}

final class PreviewGiftsDetailView: BaseView {
    private let giftsHeaderView = IVHeaderLabel(text: "Gifts")
    private let giftsStackView = UIStackView()
    
    let previewMode: Bool
    
    weak var delegate: PreviewGiftsDetailViewDelegate?
    
    init(previewMode: Bool) {
        self.previewMode = previewMode
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        layer.cornerRadius = 10
        backgroundColor = .white
        
        giftsStackView.axis = .vertical
        giftsStackView.spacing = 16
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            giftsHeaderView,
            giftsStackView
        ].forEach(addSubview)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        giftsHeaderView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), excludingEdge: .bottom)
        
        giftsStackView.autoPinEdge(.top, to: .bottom, of: giftsHeaderView, withOffset: 16)
        giftsStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), excludingEdge: .top)
    }
    
    public func configure(with model: GiftDetailsViewModel,
                          user: IVUser?,
                          guests: [Guest]) {
        giftsStackView.subviews.forEach({ $0.removeFromSuperview() })
        model.gifts.forEach({ gift in
            let reviewGiftView = PreviewGiftView()
            let isOwnedByCurrentUser = user?.userId == gift.gifterEmail
            let gifter: Guest? = guests.first { $0.email == gift.gifterEmail ?? "" }
            reviewGiftView.configure(with: gift,
                                     isOwnedByCurrentUser: isOwnedByCurrentUser,
                                     gifter: gifter,
                                     previewMode: previewMode)
            reviewGiftView.delegate = self
            giftsStackView.addArrangedSubview(reviewGiftView)
        })
    }
}

extension PreviewGiftsDetailView: PreviewGiftViewDelegate {
    func previewGiftViewDidTapLinkButton(_ gift: Gift) {
        delegate?.previewGiftViewDidTapLinkButton(gift)
    }
    
    func previewGiftViewDidTapBringButton(_ gift: Gift) {
        delegate?.previewGiftViewDidTapBringButton(gift)
    }
}
