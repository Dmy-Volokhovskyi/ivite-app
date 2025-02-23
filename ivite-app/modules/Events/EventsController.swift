import UIKit

protocol EventsEventHandler: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func didTouchMenu(for indexPath: IndexPath?)
    func createNewEventButtonTouch()
    
}

protocol EventsDataSource: AnyObject {
    var numberOfRows: Int { get }
    var numberOfSections: Int { get }
    var user: IVUser? { get }
    
    func eventCardModel(for indexPath: IndexPath) -> Event
}

final class EventsController: BaseViewController {
    private let eventHandler: EventsEventHandler
    private let dataSource: EventsDataSource
    
    private let searchBarView: MainSearchBarView
    private let createNewEventButton = UIButton(configuration: .primary(title: "Create New Event", image: nil))
    private let listHeaderView: ListHeaderView
    private let invitesLeftView = InvitesLeftView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let tableViewBackgroundView = TableViewBackgroundView()
    
    init(eventHandler: EventsEventHandler, dataSource: EventsDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        self.searchBarView = MainSearchBarView(isLoggedIn: dataSource.user == nil, profileImageURL: dataSource.user?.profileImageURL)
        self.listHeaderView = ListHeaderView(actionButton: createNewEventButton, title: "Event List")
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = .white
        
        createNewEventButton.addTarget(self, action: #selector(createNewEventButtonTouch), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.backgroundView = tableViewBackgroundView
        tableView.showsVerticalScrollIndicator = false
        
        tableViewBackgroundView.configure(text: "Your event list is empty")
        
        tableView.register(EventCardCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            searchBarView,
            listHeaderView,
            invitesLeftView,
            tableView
        ].forEach({ view.addSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        searchBarView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 8,
                                                                         left: 16,
                                                                         bottom: .zero,
                                                                         right: 16),
                                                      excludingEdge: .bottom)
        
        listHeaderView.autoPinEdge(.top, to: .bottom, of: searchBarView, withOffset: 21)
        listHeaderView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        listHeaderView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        invitesLeftView.autoPinEdge(.top, to: .bottom, of: listHeaderView, withOffset: 16)
        invitesLeftView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        invitesLeftView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        tableView.autoPinEdge(.top, to: .bottom, of: invitesLeftView)
        tableView.autoPinEdgesToSuperviewSafeArea(with: .init(top: 16, left: 16, bottom: .zero, right: 16),
                                                  excludingEdge: .top)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHandler.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventHandler.viewWillAppear()
    }
    
    @objc private func createNewEventButtonTouch(_ sender: UIButton) {
        eventHandler.createNewEventButtonTouch()
    }
}

extension EventsController: EventsViewInterface {
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func updateSearchBar() {
        
        if let remainingInvites = dataSource.user?.remainingInvites {
            invitesLeftView.configure(invitesLeft: remainingInvites)
        }
    }
}

extension EventsController: UITableViewDelegate {
    
}

extension EventsController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView?.isHidden = dataSource.numberOfSections != 0
        return dataSource.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 16 : 8
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == dataSource.numberOfSections ? 16 : 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(EventCardCell.self, for: indexPath)
        cell.configure(with: dataSource.eventCardModel(for: indexPath))
        cell.delegate = self
        return cell
    }
}

extension EventsController: EventCardCellDelegate {
    func didTouchMenu(for cell: BaseTableViewCell) {
        eventHandler.didTouchMenu(for: tableView.indexPath(for: cell))
    }
}
