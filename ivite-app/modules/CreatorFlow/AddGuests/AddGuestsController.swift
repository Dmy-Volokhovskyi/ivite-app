import UIKit

protocol AddGuestsEventHandler: AnyObject {
    func didTouchBackButton()
    func didTouchNextButton()
}

protocol AddGuestsDataSource: AnyObject {
    var numberOfRows: Int { get }
    func getAddedGuest(for indexPath: IndexPath) -> Guest
}

final class AddGuestsController: BaseViewController {
    private let eventHandler: AddGuestsEventHandler
    private let dataSource: AddGuestsDataSource
    
    private let addGuestHeaderView = IVHeaderLabel(text: "Add/Import guests")
    private let addGuestMenuView = AddGuestMenuView()
    private let addedGuestHeaderView = IVHeaderLabel(text: "Added Guests")
    private let searchFilterView = SearchFilterView()
    private let addedGuestListTableView = UITableView(frame: .zero, style: .plain)
    
    private let bottomBarView = UIView()
    private let bottomDividerView = DividerView()
    private let backButton = UIButton(configuration: .image(image: .chewroneBack))
    private let nextButton = UIButton(configuration: .primary(title: "Next"))

    init(eventHandler: AddGuestsEventHandler, dataSource: AddGuestsDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = .white
        
        addedGuestListTableView.delegate = self
        addedGuestListTableView.dataSource = self
        addedGuestListTableView.separatorStyle = .none
        
        addedGuestListTableView.register(GuestCell.self)
        
        backButton.addTarget(self, action: #selector(didTouchBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTouchNextButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        bottomBarView.addSubview(bottomDividerView)
        bottomBarView.addSubview(backButton)
        bottomBarView.addSubview(nextButton)
        
        [
            addGuestHeaderView,
            addGuestMenuView,
            addedGuestHeaderView,
            searchFilterView,
            addedGuestListTableView,
            bottomBarView
        ].forEach(view.addSubview)
        
    }
     
    override func constrainSubviews() {
        super.constrainSubviews()
        
        addGuestHeaderView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 24, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
        
        addGuestMenuView.autoPinEdge(.top, to: .bottom, of: addGuestHeaderView, withOffset: 24)
        addGuestMenuView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        addGuestMenuView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        addedGuestHeaderView.autoPinEdge(.top, to: .bottom, of: addGuestMenuView, withOffset: 24)
        addedGuestHeaderView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        addedGuestHeaderView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        searchFilterView.autoPinEdge(.top, to: .bottom, of: addedGuestHeaderView, withOffset: 16)
        searchFilterView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        searchFilterView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        addedGuestListTableView.autoPinEdge(.top, to: .bottom, of: searchFilterView, withOffset: 16)
        addedGuestListTableView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        addedGuestListTableView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        bottomBarView.autoPinEdge(.top, to: .bottom, of: addedGuestListTableView)
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
    
    @objc private func didTouchBackButton(_ sender: UIButton) {
        eventHandler.didTouchBackButton()
    }
    
    @objc private func didTouchNextButton(_ sender: UIButton) {
        eventHandler.didTouchNextButton()
    }
}

extension AddGuestsController: AddGuestsViewInterface {
}

extension AddGuestsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GuestCell.self, for: indexPath)
        
//        // Display recommended fonts in section 0, and all fonts in section 1
//        let fontName = indexPath.section == 0 ? recommendedFonts[indexPath.row] : fontFamilies[indexPath.row]
//        let isSelected = fontName == selectedFont
        cell.configure(with: dataSource.getAddedGuest(for: indexPath))
        return cell
    }
}

extension AddGuestsController: UITableViewDelegate {
    
}
