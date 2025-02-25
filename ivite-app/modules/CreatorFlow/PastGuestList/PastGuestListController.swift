import UIKit

protocol PastGuestListEventHandler: AnyObject {
    func toggleEventSelection(_ indePath: Int)
    func searchFieldTextFieldDidChange(_ text: String?)
    func searchFilterViewDidTapFilterButton()
    func searchFilterViewDidTapDeleteButton()
    func didTapAdd()
    func viewDidLoad()
}

protocol PastGuestListDataSource: AnyObject {
    var numberOfEvents: Int { get }
    
    func event(at index: Int) -> (Event?, Bool)
}

final class PastGuestListController: BaseViewController {
    private let eventHandler: PastGuestListEventHandler
    private let dataSource: PastGuestListDataSource
    
    private let searchFilterView = SearchFilterView()
    private let dividerView = DividerView()
    private let mainStackView = UIStackView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let addButton = UIButton(configuration: .secondary(title: "Add"))

    init(eventHandler: PastGuestListEventHandler, dataSource: PastGuestListDataSource) {
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
        
        searchFilterView.delegate = self
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        
        setupTableView()
        
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        
        title = "Event Guest Lists"
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            searchFilterView,
            dividerView,
            mainStackView,
            addButton
        ].forEach { view.addSubview($0) }

        mainStackView.addArrangedSubview(tableView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        searchFilterView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16), excludingEdge: .bottom)
        
        dividerView.autoPinEdge(.top, to: .bottom, of: searchFilterView, withOffset: 24)
        dividerView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 16)
        dividerView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 16)
        
        mainStackView.autoPinEdge(.top, to: .bottom, of: dividerView, withOffset: 12)
        mainStackView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 16)
        mainStackView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 16)
        
        addButton.autoPinEdge(.top, to: .bottom, of: mainStackView, withOffset: -32)
        addButton.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 24, left: 16, bottom: 12, right: 16), excludingEdge: .top)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHandler.viewDidLoad()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.sectionHeaderTopPadding = 0
        tableView.register(PastListCell.self)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
    }
    
    @objc private func didTapAdd(_ sender: UIButton) {
        eventHandler.didTapAdd()
    }
}

extension PastGuestListController: PastGuestListViewInterface {
    func updateSearchBar(with filter: FilterType, text: String?) {
        searchFilterView.configure(filter: filter, text: text)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

extension PastGuestListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfEvents
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(PastListCell.self, for: indexPath)
        let tuple = dataSource.event(at: indexPath.row)
        if let event = tuple.0 {
            cell.configure(with: event, isSelected: tuple.1)
        }
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PastGuestListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .zero
    }
}

extension PastGuestListController: SearchFilterViewDelegate {
    func searchFilterViewDidTapFilterButton() {
        eventHandler.searchFilterViewDidTapFilterButton()
    }
    
    func searchFilterViewDidTapDeleteButton() {
        eventHandler.searchFilterViewDidTapDeleteButton()
    }
    
    func searchFieldTextFieldDidChange(_ text: String?) {
        eventHandler.searchFieldTextFieldDidChange(text)
    }
}

extension PastGuestListController: PastListCellDelegate {
    func didTouch(cell: BaseTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        eventHandler.toggleEventSelection(indexPath.row)
    }
}
