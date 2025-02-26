import UIKit

protocol PreviewInviteEventHandler: AnyObject {
    func didTapLinkButton(_ gift: Gift)
    func didTapBringButton(_ gift: Gift)
    func seeAllGuestsButtonTapped()
}

protocol PreviewInviteDataSource: AnyObject {
    var creatorFlowModel: CreatorFlowModel { get }
    var user: IVUser? { get }
    var previewMode: Bool { get }
}

final class PreviewInviteController: BaseScrollViewController {
    private let eventHandler: PreviewInviteEventHandler
    private let dataSource: PreviewInviteDataSource
    
    private let contentStackView = UIStackView()
    private let invitationImageView = UIImageView()
    private let previewMainDetailView = PreviewMainDetailView()
    private let previewLocationDetailView = PreviewLocationDetailView()
    private let previewGiftsDetailView: PreviewGiftsDetailView
    private let previewGuestsDetailView = PreviewGuestsView()
    
    init(eventHandler: PreviewInviteEventHandler, dataSource: PreviewInviteDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        self.previewGiftsDetailView = PreviewGiftsDetailView(previewMode: dataSource.previewMode)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = .dark10
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        
        invitationImageView.sd_setImage(with: URL(string: dataSource.creatorFlowModel.canvasImageURL ?? ""))
        invitationImageView.layer.cornerRadius = 9
        invitationImageView.clipsToBounds = true
        
        previewMainDetailView.configure(model: dataSource.creatorFlowModel.eventDetailsViewModel)
        previewLocationDetailView.configure(model: dataSource.creatorFlowModel.eventDetailsViewModel)
        previewGiftsDetailView.configure(with: dataSource.creatorFlowModel.giftDetailsViewModel,
                                         user: dataSource.user,
                                         guests: dataSource.creatorFlowModel.guests)
        previewGiftsDetailView.delegate = self
        previewGuestsDetailView.configure(with: dataSource.creatorFlowModel.guests, isPreview: dataSource.previewMode)
        previewGuestsDetailView.delegate = self
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        contentView.addSubview(contentStackView)
        
        [
            invitationImageView,
            previewMainDetailView,
            previewLocationDetailView,
            previewGiftsDetailView,
            previewGuestsDetailView
        ].forEach(contentStackView.addArrangedSubview)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        contentStackView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        
        invitationImageView.autoMatch(.height, to: .width, of: invitationImageView, withMultiplier: 491 / 343)
    }
}

extension PreviewInviteController: PreviewInviteViewInterface {
}

extension PreviewInviteController: PreviewGiftsDetailViewDelegate {
    func previewGiftViewDidTapLinkButton(_ gift: Gift) {
        eventHandler.didTapLinkButton(gift)
    }
    
    func previewGiftViewDidTapBringButton(_ gift: Gift) {
        eventHandler.didTapBringButton(gift)
    }
}

extension PreviewInviteController: PreviewGuestsViewDelegate {
    func seeAllGuestsButtonTapped() {
        eventHandler.seeAllGuestsButtonTapped()
    }
}
