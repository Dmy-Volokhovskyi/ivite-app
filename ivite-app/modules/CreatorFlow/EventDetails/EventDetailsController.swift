import UIKit

protocol EventDetailsEventHandler: AnyObject {
    func didTapAddCoHostButton()
    func didTapPickDateButton()
    func didTouchMenu(for coHost: CoHost)
    func didTouchBackButton()
    func didTouchNextButton()
    func didSelectTimeZone(_ timeZone: String)
    func requestDeleteItem(for bringItem: BringListItem)
}

protocol EventDetailsDataSource: AnyObject {
    var coHosts: [CoHost] { get }
    var model: EventDetailsViewModel { get }
    var selectedTimeZone: String? { get }
    var nexButtonTitle: String { get }
}

final class EventDetailsController: BaseScrollViewController {
    private let eventHandler: EventDetailsEventHandler
    private let dataSource: EventDetailsDataSource
    
    private let stackView = UIStackView()
    private let eventDetailsView: EventDetailsView
    private let hostDetailsView: HostView
    private let locationsViewDetail: LocationsView
    var noteFromHostView: NoteFromHostView
    var bringListDetailView: BringListDetailView
    
    private let bottomBarView = UIView()
    private let bottomDividerView = DividerView()
    private let backButton = UIButton(configuration: .image(image: .chewroneBack))
    private let nextButton = UIButton(configuration: .primary(title: "Next"))
    
    init(eventHandler: EventDetailsEventHandler, dataSource: EventDetailsDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        self.eventDetailsView = EventDetailsView(model: dataSource.model)
        self.hostDetailsView = HostView(model: dataSource.model)
        self.bringListDetailView = BringListDetailView(model: dataSource.model)
        self.locationsViewDetail = LocationsView(model: dataSource.model)
        self.noteFromHostView = NoteFromHostView(model: dataSource.model)
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
        bringListDetailView.delegate = self
        
        backButton.addTarget(self, action: #selector(didTouchBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTouchNextButton), for: .touchUpInside)
        view.backgroundColor = .white
        
        nextButton.IVsetEnabled(dataSource.model.isReadyToSave, title: dataSource.nexButtonTitle)
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
    
    private func setUpBottomViewConstraints() {
        bottomDividerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        backButton.autoPinEdge(.top, to: .bottom, of: bottomDividerView, withOffset: 24)
        
        backButton.autoPinEdge(toSuperviewEdge: .leading)
        backButton.autoPinEdge(.trailing, to: .leading, of: nextButton, withOffset: -12)
        backButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 8)
        backButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        backButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        nextButton.autoPinEdge(.top, to: .bottom, of: bottomDividerView, withOffset: 24)
        nextButton.autoPinEdge(toSuperviewEdge: .trailing)
        nextButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 8)
        
        nextButton.setContentHuggingPriority(.init(1), for: .horizontal)
        nextButton.setContentCompressionResistancePriority(.init(1), for: .horizontal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setBottomInset(inset: bottomBarView.frame.height)
    }
    
    private func showTimeZonePicker(sender: UIView) {
        let controller = TimeZonePickerController(selectedTimeZoneIdentifier: dataSource.selectedTimeZone)
        controller.delegate = self
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.sourceView = sender
        controller.popoverPresentationController?.delegate = self
        present(controller, animated: true)
    }
    
    @objc private func didTouchBackButton(_ sender: UIButton) {
        eventHandler.didTouchBackButton()
    }
    
    @objc private func didTouchNextButton(_ sender: UIButton) {
        let model = dataSource.model
        print("Event Title: \(model.eventTitle ?? "None")")
        print("Date: \(model.date?.description ?? "None")")
        print("Time Zone: \(model.timeZone ?? "None")")
        
        // Host
        print("Host Name: \(model.hostName ?? "None")")
        print("Co-Hosts: \(model.coHosts.map { $0.name })") // Replace `description` with a relevant property if needed
        
        // Location
        print("City: \(model.city ?? "None")")
        print("Location: \(model.location ?? "None")")
        print("State: \(model.state ?? "None")")
        print("Zip Code: \(model.zipCode ?? "None")")
        
        // Notes
        print("Note: \(model.note ?? "None")")
        
        // Bring List
        print("Is Bring List Active: \(model.isBringListActive ? "Yes" : "No")")
        print("Bring List: \(model.bringList.map { $0.name })")
        eventHandler.didTouchNextButton()
    }
}

extension EventDetailsController: EventDetailsViewInterface {
    func updateBringList() {
        bringListDetailView.updateModel(with: dataSource.model)
    }
    
    func isReadyToSaveChanges(ready: Bool) {
        nextButton.IVsetEnabled(ready, title: dataSource.nexButtonTitle)
    }
    
    func updateTimezone(with timeZone: String) {
        eventDetailsView.updateTimezone(with: timeZone)
    }
    
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
    func eventDetailsViewDidTapPickTimezone(_ view: IVControl) {
        showTimeZonePicker(sender: view)
    }
    
    func eventDetailsViewDidTapPickDate(_ view: EventDetailsView) {
        eventHandler.didTapPickDateButton()
    }
}

extension EventDetailsController: TimeZonePickerDelegate {
    func didSelectTimeZone(_ timeZone: String) {
        print("Selected TimeZone: \(timeZone)")
        eventHandler.didSelectTimeZone(timeZone)
        dismiss(animated: true)
    }
}

extension EventDetailsController: BringListDetailViewDelegate {
    func bringListDetailView(_ view: BringListDetailView, requestDeleteItem item: BringListItem) {
        eventHandler.requestDeleteItem(for: item)
    }
}

extension EventDetailsController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}
