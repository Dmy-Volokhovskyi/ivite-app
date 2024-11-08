import UIKit

protocol GiftingOptionsEventHandler: AnyObject {
    func didTouchDeletePhotoButton()
    func didTouchBackButton()
    func didTouchNextButton()
    func didAddGift(gift: Gift)
    func didTouchMenuButton(for gift: Gift)
}

protocol GiftingOptionsDataSource: AnyObject {
    var gifts: [Gift] { get }
}

final class GiftingOptionsController: BaseScrollViewController {
    private let eventHandler: GiftingOptionsEventHandler
    private let dataSource: GiftingOptionsDataSource
    
    private let photoLibraryManager = PhotoLibraryManager()
    
    private let contentStackView = UIStackView()
    private let addGiftView: AddGiftView
    private let addImageView = GiftRegistryView()
    private let divideView = DividerView()
    private let giftsView: GiftListView
    
    private let bottomBarView = UIView()
    private let bottomDividerView = DividerView()
    private let backButton = UIButton(configuration: .image(image: .chewroneBack))
    private let nextButton = UIButton(configuration: .primary(title: "Next"))
    
    init(eventHandler: GiftingOptionsEventHandler, dataSource: GiftingOptionsDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        self.giftsView = GiftListView(gifts: dataSource.gifts)
        self.addGiftView = AddGiftView(photoLibraryManager: photoLibraryManager, addImageView: addImageView )
        super.init()
        
        divideView.isHidden = dataSource.gifts.isEmpty
        giftsView.isHidden = dataSource.gifts.isEmpty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = .white
        bottomBarView.backgroundColor = .white
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 24
        
        addImageView.delegate = self
        addGiftView.delegate = self
        
        giftsView.delegate = self
        
        backButton.addTarget(self, action: #selector(didTouchBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTouchNextButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        bottomBarView.addSubview(bottomDividerView)
        bottomBarView.addSubview(backButton)
        bottomBarView.addSubview(nextButton)
        
        view.addSubview(bottomBarView)
        
        contentView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(addGiftView)
        contentStackView.addArrangedSubview(divideView)
        contentStackView.addArrangedSubview(giftsView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        contentStackView.autoPinEdgesToSuperviewSafeArea()
        
        bottomBarView.autoPinEdgesToSuperviewEdges(with:.zero, excludingEdge: .top)
        
        setUpBottomViewConstraints()
    }
    
    private func setUpBottomViewConstraints() {
        bottomDividerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        backButton.autoPinEdge(.top, to: .bottom, of: bottomDividerView, withOffset: 24)
        
        backButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        backButton.autoPinEdge(.trailing, to: .leading, of: nextButton, withOffset: -12)
        backButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 8)
        backButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        backButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        nextButton.autoPinEdge(.top, to: .bottom, of: bottomDividerView, withOffset: 24)
        nextButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        nextButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 8)
        
        nextButton.setContentHuggingPriority(.init(1), for: .horizontal)
        nextButton.setContentCompressionResistancePriority(.init(1), for: .horizontal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setBottomInset(inset: bottomBarView.frame.height)
    }
    
    internal func showAccessDeniedAlert() {
        let alert = UIAlertController(
            title: "Access Denied",
            message: "Please enable photo library access in settings to add images.",
            preferredStyle: .alert
        )
        
        // Action to open Settings
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        })
        
        // Action to dismiss the alert
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    @objc private func didTouchBackButton(_ sender: UIButton) {
        eventHandler.didTouchBackButton()
    }
    
    @objc private func didTouchNextButton(_ sender: UIButton) {
        eventHandler.didTouchNextButton()
    }
}

extension GiftingOptionsController: GiftingOptionsViewInterface {
    func updateGifts(with gifts: [Gift]) {
        giftsView.updateGifts(gifts: gifts)
        divideView.isHidden = dataSource.gifts.isEmpty
        giftsView.isHidden = dataSource.gifts.isEmpty
    }
}

extension GiftingOptionsController: GiftRegistryViewDelegate {
    func giftRegistryViewDidRequestDeleteImage(_ view: GiftRegistryView) {
        eventHandler.didTouchDeletePhotoButton()
        view.displayImage(nil)
    }
    
    func giftRegistryViewDidRequestPhotoLibraryAccess(_ view: GiftRegistryView) {
        Task {
            await PhotoLibraryManager.shared.requestPhotoLibraryAccess(from: self) { [weak self] selectedImage in
                if let image = selectedImage {
                    // Handle the selected image, e.g., display it in the view
                    self?.addImageView.displayImage(image) // Add this method in your custom view if needed
                }
            }
        }
    }
}

extension GiftingOptionsController: AddGiftViewDelegate {
    func didAddGift(_ gift: Gift) {
        eventHandler.didAddGift(gift: gift)
    }
}

extension GiftingOptionsController: GiftListViewDelegate {
    func didTouchMenuButton(for gift: Gift) {
        eventHandler.didTouchMenuButton(for: gift)
    }
}
