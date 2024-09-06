import UIKit

protocol EventsEventHandler: AnyObject {
    func viewDidLoad()
    func didTouchMenu(for indexPath: IndexPath?)
}

protocol EventsDataSource: AnyObject {
    var numberOfRows: Int { get }
    var numberOfSections: Int { get }
    
    func eventCardModel(for indexPath: IndexPath) -> EventCardModel
}

final class EventsController: BaseViewController {
    private let eventHandler: EventsEventHandler
    private let dataSource: EventsDataSource
    
    private let searchBarView = MainSearchBarView()
    private let listHeaderView = ListHeaderView(actionButton: UIButton(configuration: .primary(title: "Create New Event", image: nil)), title: "Event List")
    private let invitesLeftView = InvitesLeftView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let tableViewBackgroundView = TableViewBackgroundView()
    
    init(eventHandler: EventsEventHandler, dataSource: EventsDataSource) {
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
        
        invitesLeftView.configure(invitesLeft: "136")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.backgroundView = tableViewBackgroundView
        tableView.showsVerticalScrollIndicator = false
        
        tableViewBackgroundView.configure(text: "Your event list is empty")
        
        tableView.register(EventCardCell.self)
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
        tableView.autoPinEdgesToSuperviewSafeArea(with: .init(top: 16, left: 16, bottom: 16, right: 16),
                                                  excludingEdge: .top)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHandler.viewDidLoad()
    }
}

extension EventsController: EventsViewInterface {
    func reloadTableView() {
        tableView.reloadData()
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
