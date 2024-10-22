import UIKit

// TODO: - ADd SCroll inset ++
// TODO: - add keyboard dismiss fot scrollView ++
// TODO: - add regex support++
// TODO: - make allertSheet
// TODO: - make editSheet
// TODO: - add secondryButtonStyle
// TODO: - add time Picker++
// TODO: - add cohost addition sheet.
// TODO: - add cohost deletion sheet
// TODO: - add date picker++
// TODO: - add time picker++

protocol EventDetailsEventHandler: AnyObject {
    func didTapAddCoHostButton()
    func didTapPickDateButton()
    func didTouchMenu(for coHost: CoHost)
}

protocol EventDetailsDataSource: AnyObject {
    var coHosts: [CoHost] { get }
    var model: EventDetailsViewModel { get }
}

final class EventDetailsController: BaseScrollViewController {
    private let eventHandler: EventDetailsEventHandler
    private let dataSource: EventDetailsDataSource
    
    private let stackView = UIStackView()
    #warning("Put the righ model in")
    private let eventDetailsView = EventDetailsView(model: EventDetailsViewModel( coHosts: []))
    private let hostDetailsView: HostView
    var locationsViewDetail = LocationsView(model: EventDetailsViewModel( coHosts: [CoHost(name: "Anna Smith", email: "")]))
    var noteFromHostView = NoteFromHostView(model: EventDetailsViewModel( coHosts: [CoHost(name: "Anna Smith", email: "")]))
    var bringListDetailView: BringListDetailView
    private let bottomBarView = UIView()
    private let bottomDividerView = DividerView()
    private let backButton = UIButton(configuration: .image(image: .chewroneBack))
    private let nextButton = UIButton(configuration: .primary(title: "Next"))
    
    init(eventHandler: EventDetailsEventHandler, dataSource: EventDetailsDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        self.hostDetailsView = HostView(model: dataSource.model)
        self.bringListDetailView = BringListDetailView(model: dataSource.model)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        stackView.axis = .vertical
        
        bottomBarView.backgroundColor = .white
        hostDetailsView.delegate = self
        eventDetailsView.delegate = self
        
        view.backgroundColor = .white
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        contentView.addSubview(stackView)
        view.addSubview(bottomBarView)
        
        bottomBarView.addSubview(bottomDividerView)
        bottomBarView.addSubview(backButton)
        bottomBarView.addSubview(nextButton)
        [
            eventDetailsView,
            DividerView(topSpace: 24, bottomSpace: 24),
            hostDetailsView,
            DividerView(topSpace: 24, bottomSpace: 24),
            locationsViewDetail,
            DividerView(topSpace: 24, bottomSpace: 24),
            noteFromHostView,
            DividerView(topSpace: 24, bottomSpace: 24),
            bringListDetailView
        ].forEach({ stackView.addArrangedSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        stackView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 24,
                                                                     left: 16,
                                                                     bottom: 16,
                                                                     right: 16))
        
        bottomBarView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16), excludingEdge: .top)
        setUpBottomViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure the navigation bar is visible
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//        self.title = "My Custom Title1"
//           
//           // Or, if you need a custom label
//           let titleLabel = UILabel()
//           titleLabel.text = "My Custom Title"
//           titleLabel.sizeToFit()
//           titleLabel.textAlignment = .center
//           navigationItem.titleView = titleLabel
    }
    
    private func setUpBottomViewConstraints() {
        bottomDividerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        backButton.autoPinEdge(.top, to: .bottom, of: bottomDividerView, withOffset: 24)
        
        backButton.autoPinEdge(toSuperviewEdge: .leading)
        backButton.autoPinEdge(.trailing, to: .leading, of: nextButton, withOffset: -12)
        backButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
//        backButton.autoAlignAxis(.horizontal, toSameAxisOf: nextButton)
        backButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        backButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
//        nextButton.autoPinEdge(.leading, to: .trailing, of: backButton, withOffset: 12)
        nextButton.autoPinEdge(.top, to: .bottom, of: bottomDividerView, withOffset: 24)
        nextButton.autoPinEdge(toSuperviewEdge: .trailing)
        nextButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
        
        nextButton.setContentHuggingPriority(.init(1), for: .horizontal)
        nextButton.setContentCompressionResistancePriority(.init(1), for: .horizontal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setBottomInset(inset: bottomBarView.frame.height)
    }
}

extension EventDetailsController: EventDetailsViewInterface {
    func updateDateView(with time: String, date: String) {
        eventDetailsView.updateTimeDate(with: time, date: date)
    }
    
    func updateCohostView() {
        hostDetailsView.updateCoHosts(dataSource.model.coHosts)
    }
}

extension EventDetailsController: HostViewDelegate {
    func didTouchMenu(for coHost: CoHost) {
        eventHandler.didTouchMenu(for: coHost)
    }
    
    func didTapAddCoHostButton() {
        eventHandler.didTapAddCoHostButton()
    }
}

extension EventDetailsController: EventDetailsViewDelegate {
    func eventDetailsViewDidTapPickDate(_ view: EventDetailsView) {
        eventHandler.didTapPickDateButton()
    }
}
