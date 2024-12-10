//
//  CreateGroupView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 25/11/2024.
//

import UIKit

protocol CreateGroupViewDelegate: AnyObject {
    func didCreateGroup(_ group: ContactGroup, contacts: [ContactCardModel])
    func didTouchCancel()
}

final class CreateGroupView: BaseView {
    private let groupNameHeader: IVHeaderLabel = .init(text: "Create group")
    private let groupNameTextField = IVTextField(placeholder: "Your group name")
    private let groupNameEntry = EntryWithTitleView(title: "Group name")
    private let divider = DividerView()
    private let addUsersLabel = UILabel()
    private let contactsTableView = UITableView(frame: .zero, style: .grouped)
    private let tableViewBackgroundView = TableViewBackgroundView()
    private let saveButton = UIButton(configuration: .primary(title: "Save"))
    private let cancelButton = UIButton(configuration: .secondary(title: "Cancel"))
    
    private let contacts: [ContactCardModel]
    private var group: ContactGroup
    
    weak var delegate: CreateGroupViewDelegate?
    
    init(contacts: [ContactCardModel], group: ContactGroup? = nil) {
        self.contacts = contacts
        self.group = group ?? ContactGroup(name: "")
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        groupNameTextField.delegate = self
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.register(GroupCell.self)
        contactsTableView.backgroundView = tableViewBackgroundView
        contactsTableView.separatorStyle = .none
        contactsTableView.backgroundColor = .white
        
        tableViewBackgroundView.configure(text: "Your contact list is empty", image: .mailbox)
        
        addUsersLabel.text = "Add users to a group"
        groupNameEntry.setContentView(groupNameTextField)
        
        saveButton.IVsetEnabled(false, title: "Save")
        saveButton.addTarget(self, action: #selector(didTouchSaveButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTouchCancelButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            groupNameHeader,
            groupNameEntry,
            divider,
            addUsersLabel,
            contactsTableView,
            saveButton,
            cancelButton
        ].forEach(addSubview)
        
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        groupNameHeader.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), excludingEdge: .bottom)
        
        groupNameEntry.autoPinEdge(.top, to: .bottom, of: groupNameHeader, withOffset: 24)
        groupNameEntry.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        groupNameEntry.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        
        divider.autoPinEdge(.top, to: .bottom, of: groupNameEntry, withOffset: 24)
        divider.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        divider.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        
        addUsersLabel.autoPinEdge(.top, to: .bottom, of: divider, withOffset: 24)
        addUsersLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        addUsersLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        
        contactsTableView.autoPinEdge(.top, to: .bottom, of: addUsersLabel, withOffset: 8)
        contactsTableView.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        contactsTableView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        contactsTableView.autoMatch(.height, to: .width, of: contactsTableView, withMultiplier: 0.8)
        
        saveButton.autoPinEdge(.top, to: .bottom, of: contactsTableView, withOffset: 8)
        saveButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        saveButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        
        cancelButton.autoPinEdge(.top, to: .bottom, of: saveButton, withOffset: 8)
        cancelButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        cancelButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        cancelButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 24)
    }
    
    private func setupGroupView() {
        
    }
    
    @objc private func didTouchSaveButton(_ sender: UIButton) {
        delegate?.didCreateGroup(group, contacts: contacts)
    }
    
    @objc private func didTouchCancelButton(_ sender: UIButton) {
        delegate?.didTouchCancel()
    }
}

extension CreateGroupView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = contacts.count != 0
        return contacts.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GroupCell.self, for: indexPath)
        let contact = contacts[indexPath.row]
        
        let isSelected = group.members.contains(contact)
        
        cell.configure(with: contact, isSelected: isSelected)
        
        return cell
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
        .zero
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .zero
    }
}

extension CreateGroupView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? GroupCell else { return }
        if cell.isAdded {
            group.removeMember(by: contacts[indexPath.row].id)
        } else {
            group.addMember(contacts[indexPath.row])
        }
        contactsTableView.reloadData()
    }
}

extension CreateGroupView: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        guard let text = textField.text else { return }
        group.name = text
        let isValid = group.name.isEmpty == false
        saveButton.IVsetEnabled(isValid, title: "Save")
    }
}
