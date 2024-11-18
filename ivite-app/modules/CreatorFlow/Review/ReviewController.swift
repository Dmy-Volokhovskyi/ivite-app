import UIKit

protocol ReviewEventHandler: AnyObject {
    func didTouchBackButton()
    func didTouchNextButton()
}

protocol ReviewDataSource: AnyObject {
}

final class ReviewController: BaseScrollViewController {
    private let eventHandler: ReviewEventHandler
    private let dataSource: ReviewDataSource
    
    private let contentStackView = UIStackView()
    private let invitationImageView = UIImageView()
    private let reviewMainDetailView = ReviewMainDetailView()
    private let reviewLocationDetailView = ReviewLocationDetailView()
    private let reviewGiftsDetailView = ReviewGiftsDetailView()
    private let reviewGuestsDetailView = ReviewGuestsDetailView()
    
    private let bottomBarView = UIView()
    private let bottomDividerView = DividerView()
    private let backButton = UIButton(configuration: .image(image: .chewroneBack))
    private let nextButton = UIButton(configuration: .primary(title: "Next"))
    private let reviewOptionsStack = UIStackView()
    private let previewButton = UIButton(configuration: .transparent(title: "Preview as Guest", image: .eyeOpen.withRenderingMode(.alwaysTemplate)))
    private let emailPreview = UIButton(configuration: .transparent(title: "Email Me a Preview", image: .externalLink))
    
    init(eventHandler: ReviewEventHandler, dataSource: ReviewDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = .dark10
        bottomBarView.backgroundColor = .white
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        
        invitationImageView.image = .testInvite
        invitationImageView.layer.cornerRadius = 9
        invitationImageView.clipsToBounds = true
        
//        let example = EventDetailsViewModel(
//            eventTitle: "Birthday Bash",
//            date: Date(),
//            hostName: "Alice Johnson",
//            coHosts: [
//                CoHost(name: "Bob Smith", email: "bob.smith@example.com"),
//                CoHost(name: "Charlie Brown", email: "charlie.brown@example.com")
//            ],
//            city: "New York",
//            location: "Central Park",
//            state: "NY",
//            zipCode: "10001",
//            note: "Join us for an unforgettable birthday celebration with food, games, and music!",
//            isBringListActive: true,
//            bringList: [
//                BringListItem(name: "Cake", count: 1),
//                BringListItem(name: "Chairs", count: 20),
//                BringListItem(name: "Drinks", count: 50),
//                BringListItem(name: "Party Hats", count: 30)
//            ]
//        )
        
        let gift1 = Gift(name: "Chocolate Box", link: "https://example.com/chocolate", image: nil)
        let gift2 = Gift(name: "Book", link: "https://example.com/book", image: nil)
        let gift3 = Gift(name: "Flower Bouquet", link: nil, image:  UIImage.testInvite.pngData())
        
        // Collecting them in an array
        let gifts: [Gift] = [gift1, gift2, gift3]
        let giftDetailsViewModel = GiftDetailsViewModel()
        giftDetailsViewModel.gifts = gifts
        
//        reviewMainDetailView.configure(model: example )
//        reviewLocationDetailView.configure(model: example)
        reviewGiftsDetailView.configure(with: giftDetailsViewModel)
        reviewGuestsDetailView.configre(with: [Guest(name: " Bam Bam", email: "@bam.com", phone: "No Phone"),
                                               Guest(name: " Bam Bam!", email: "HEJOOO@bam.com", phone: "No Phone")])
        
        reviewOptionsStack.spacing = 24
        reviewOptionsStack.distribution = .fillEqually
        reviewOptionsStack.alignment = .center
        
        backButton.addTarget(self, action: #selector(didTouchBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTouchNextButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        bottomBarView.addSubview(bottomDividerView)
        bottomBarView.addSubview(backButton)
        bottomBarView.addSubview(nextButton)
        bottomBarView.addSubview(reviewOptionsStack)
        
        reviewOptionsStack.addArrangedSubview(previewButton)
        reviewOptionsStack.addArrangedSubview(emailPreview)
        
        view.addSubview(bottomBarView)
        
        contentView.addSubview(contentStackView)
        
        [
            invitationImageView,
            reviewMainDetailView,
            reviewLocationDetailView,
            reviewGiftsDetailView,
            reviewGuestsDetailView
        ].forEach(contentStackView.addArrangedSubview)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        contentStackView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        
        //        invitationImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), excludingEdge: .bottom)
        invitationImageView.autoMatch(.height, to: .width, of: invitationImageView, withMultiplier: 491 / 343)
        //        reviewMainDetailView.autoPinEdge(.top, to: .bottom, of: invitationImageView, withOffset: 16)
        //        reviewMainDetailView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), excludingEdge: .top)
        
        bottomBarView.autoPinEdgesToSuperviewEdges(with:.zero, excludingEdge: .top)
        
        setUpBottomViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setBottomInset(inset: bottomBarView.frame.height)
    }
    
    private func setUpBottomViewConstraints() {
        bottomDividerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        backButton.autoPinEdge(.top, to: .bottom, of: bottomDividerView, withOffset: 24)
        
        backButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        backButton.autoPinEdge(.trailing, to: .leading, of: nextButton, withOffset: -12)
        backButton.autoPinEdge(.bottom, to: .top, of: reviewOptionsStack, withOffset: -12)
        backButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        backButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        nextButton.autoPinEdge(.top, to: .bottom, of: bottomDividerView, withOffset: 24)
        nextButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        nextButton.autoPinEdge(.bottom, to: .top, of: reviewOptionsStack, withOffset: -12)
        nextButton.setContentHuggingPriority(.init(1), for: .horizontal)
        nextButton.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        
        reviewOptionsStack.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16, relation: .greaterThanOrEqual)
        reviewOptionsStack.autoPinEdge(toSuperviewEdge: .leading, withInset: 16, relation: .greaterThanOrEqual)
        reviewOptionsStack.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 8)
        reviewOptionsStack.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    @objc private func didTouchBackButton(_ sender: UIButton) {
        eventHandler.didTouchBackButton()
    }
    
    @objc private func didTouchNextButton(_ sender: UIButton) {
        eventHandler.didTouchNextButton()
    }
}

extension ReviewController: ReviewViewInterface {
}
