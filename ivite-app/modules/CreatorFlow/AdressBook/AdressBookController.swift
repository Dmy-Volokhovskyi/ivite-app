import UIKit

protocol AdressBookEventHandler: AnyObject {
    func toggleContactSelection(_ contact: ContactCardModel)
    func didChangeTableMode(to groupView: Bool)
    func searchFieldTextFieldDidChange(_ text: String?)
    func searchFilterViewDidTapFilterButton()
    func searchFilterViewDidTapDeleteButton()
    func didTapSelectAllButton()
    func didTapAdd()
    func viewDidLoad()
}

protocol AdressBookDataSource: AnyObject {
    var numberOfGroups: Int { get }
    
    func group(at index: Int) -> ContactGroup?
    func contactAndSelectionState(for indexPath: IndexPath, isGroupView: Bool) -> (contact: ContactCardModel, isSelected: Bool)?
    
    var allContacts: [ContactCardModel] { get }
    var isGroup: Bool { get }
}

final class AdressBookController: BaseViewController {
    private let eventHandler: AdressBookEventHandler
    private let dataSource: AdressBookDataSource
    
    private let searchFilterView = SearchFilterView()
    private let dividerView = DividerView()
    private let switchView = CustomSegmentedControl()
    private let mainStackView = UIStackView()
    private let selectAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select all", for: .normal)
        button.setTitleColor(.accent, for: .normal) // Assuming `.accent` is your orange color
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold) // Adjust font size and weight
        button.contentHorizontalAlignment = .right // Align the text to the right
        return button
    }()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let addButton = UIButton(configuration: .primary(title: "Add"))
    
    private var collapsedSections: [Bool] = []
    
    init(eventHandler: AdressBookEventHandler, dataSource: AdressBookDataSource) {
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
        setupSegmentedControl()
        
        selectAllButton.addTarget(self, action: #selector(didTapSelectAll), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        
        title = "Adress Book"
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            searchFilterView,
            dividerView,
            switchView,
            mainStackView,
            addButton
        ].forEach { view.addSubview($0) }
        
        mainStackView.addArrangedSubview(selectAllButton)
        mainStackView.addArrangedSubview(tableView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        searchFilterView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16), excludingEdge: .bottom)
        
        dividerView.autoPinEdge(.top, to: .bottom, of: searchFilterView, withOffset: 24)
        dividerView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 16)
        dividerView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 16)
        
        switchView.autoPinEdge(.top, to: .bottom, of: dividerView, withOffset: 16)
        switchView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 16)
        switchView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 16)
   
        mainStackView.autoPinEdge(.top, to: .bottom, of: switchView, withOffset: 12)
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
        tableView.register(GuestContactCell.self)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
    }
    
    private func toggleSection(_ section: Int) {
        collapsedSections[section].toggle()
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    private func setupSegmentedControl() {
        switchView.onIndexChanged = { [weak self] index in
            guard let self = self else { return }
            self.collapsedSections = [] // Reset collapsed state
            self.tableView.reloadData()
            eventHandler.didChangeTableMode(to: index == 1)
            selectAllButton.isHidden = index == 1
        }
    }
    
    @objc private func didTapSelectAll(_ sender: UIButton) {
        eventHandler.didTapSelectAllButton()
    }
    
    @objc private func didTapAdd(_ sender: UIButton) {
        eventHandler.didTapAdd()
    }
}

extension AdressBookController: AdressBookViewInterface {
    func updateSearchBar(with filter: FilterType, text: String?) {
        searchFilterView.configure(filter: filter, text: text)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

extension AdressBookController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if switchView.selectedIndex == 1 {
            let groupCount = dataSource.numberOfGroups
            // Ensure collapsedSections is in sync with the number of groups
            if collapsedSections.count != groupCount {
                collapsedSections = Array(repeating: true, count: groupCount)
            }
            return groupCount
        }
        return 1 // Single section for "Contact" mode
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if switchView.selectedIndex == 1 { // "Group" mode
            // Ensure the section index is valid
            guard section < collapsedSections.count, let group = dataSource.group(at: section) else {
                return 0
            }
            return !collapsedSections[section] ? group.members.count : 0
        }
        return dataSource.allContacts.count // "Contact" mode
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GuestContactCell.self, for: indexPath)
        if let config = dataSource.contactAndSelectionState(for: indexPath, isGroupView: dataSource.isGroup) {
            cell.configure(with: config.0, isSelected: config.1)
            cell.delegate = self
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AdressBookController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard switchView.selectedIndex == 1, let group = dataSource.group(at: section) else {
            return nil // Only for "Group" mode
        }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier) as! SectionHeaderView
        let isCollapsed = collapsedSections[section]
        header.configure(with: group.name, section: section, isCollapsed: isCollapsed)
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        dataSource.isGroup ? 44 : .zero
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .zero
    }
    
    @objc private func headerTapped(_ gesture: UITapGestureRecognizer) {
        guard let section = gesture.view?.tag else { return }
        toggleSection(section)
    }
}

// MARK: - ContactCardCellDelegate
extension AdressBookController: GuestContactCellDelegate {
    func contactCardCell(_ cell: GuestContactCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        if switchView.selectedIndex == 1, let group = dataSource.group(at: indexPath.section) { // "Group" mode
            let contact = group.members[indexPath.row]
            eventHandler.toggleContactSelection(contact)
        } else { // "Contact" mode
            let contact = dataSource.allContacts[indexPath.row]
            eventHandler.toggleContactSelection(contact)
        }
    }
}

extension AdressBookController: SectionHeaderViewDelegate {
    func didTapSectionHeader(_ section: Int) {
        toggleSection(section) // Toggle the collapse state
    }
}

extension AdressBookController: SearchFilterViewDelegate {
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
