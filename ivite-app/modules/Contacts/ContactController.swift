import UIKit

protocol ContactEventHandler: AnyObject {
    func viewDidLoad()
    func didTouchMenu(for indexPath: IndexPath?)
    func addNewTouch()
    func didTapFilterButton()
    func searchFieldTextDidChange(_ text: String?)
    func viewWillAppear()
}

protocol ContactDataSource: AnyObject {
    var numberOfRows: Int { get }
    var numberOfSections: Int { get }
    var user: IVUser? { get }
    
    func contactCardModel(for indexPath: IndexPath) -> ContactCardModel
}

final class ContactController: BaseViewController {
    private let eventHandler: ContactEventHandler
    private let dataSource: ContactDataSource
    
    private let searchBarView: MainSearchBarView
    private let addNewButton = UIButton(configuration: .primary(title: "Add New", image: .chewronDown))
    private let listHeaderView : ListHeaderView
    private let invitesLeftView = InvitesLeftView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let tableViewBackgroundView = TableViewBackgroundView()
    
    init(eventHandler: ContactEventHandler, dataSource: ContactDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        self.searchBarView = MainSearchBarView(isLoggedIn: dataSource.user == nil, profileImageURL: dataSource.user?.profileImageURL)
        listHeaderView = ListHeaderView(actionButton: addNewButton, title: "Contact List")
        super.init()
  
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.backgroundView = tableViewBackgroundView
        tableView.showsVerticalScrollIndicator = false
        
        searchBarView.delegate = self
        
        tableViewBackgroundView.configure(text: "Your contact list is empty", image: .mailbox)
        
        listHeaderView.deeleagate = self
        addNewButton.addTarget(self, action: #selector(addNewTouch), for: .touchUpInside)
        
        tableView.register(ContactCardCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
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
    
    @objc private func addNewTouch(_ sender: UIButton) {
        eventHandler.addNewTouch()
    }
}

extension ContactController: ContactViewInterface {
    func updateLoadingState(_ isLoading: Bool) {
        // TODO: - update
    }
    
    func updateSearchBar() {
        if let remainingInvites = dataSource.user?.remainingInvites {
            invitesLeftView.configure(invitesLeft: remainingInvites)
        }
    }
    
    func updateFilter(_ filter: FilterType) {
        listHeaderView.upateSearchButton(filter)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension ContactController: UITableViewDelegate {
    
}

extension ContactController: UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(ContactCardCell.self, for: indexPath)
        cell.configure(with: dataSource.contactCardModel(for: indexPath))
        cell.delegate = self
        return cell
    }
}

extension ContactController: ContactCardCellDelegate {
    func didTouchMenu(for cell: BaseTableViewCell) {
        eventHandler.didTouchMenu(for: tableView.indexPath(for: cell))
    }
}

extension ContactController: ListHeaderViewDelegate {
    func didTapFilterButton() {
        eventHandler.didTapFilterButton()
    }
}

extension ContactController: MainSearchBarViewDelegate {
    func didTapLogInButton() {
        print("Call log in")
    }
    
    func searchFieldTextDidChange(_ text: String?) {
        eventHandler.searchFieldTextDidChange(text)
    }
}
