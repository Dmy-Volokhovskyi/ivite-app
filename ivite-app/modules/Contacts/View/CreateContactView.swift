//
//  CreateContactView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 29/11/2024.
//

import UIKit

protocol CreateContactViewDelegate: AnyObject {
    func createContact(contact: ContactCardModel, groups: [ContactGroup])
    func selectGroupCellDidTapDelete(group: ContactGroup)
    func selectGroupCellDidTapEdit(group: ContactGroup)
    func didTouchCancel()
    func createNewGroup(view: CreateContactView)
}

final class CreateContactView: BaseView {
    private let addContactHeader: IVHeaderLabel = .init(text: "Add contact")
    private let contactNameTextField = IVTextField(placeholder: "Name", leadingImage: .person)
    private let contactEmailTextField = IVTextField(placeholder: "Email contact", leadingImage: .email, validationType: .email)
    private let addGroupControl = IVControl(placeholder: "Add new group", leadingImage: .group, trailingImage: .chewronDown)
    private let groupsTableView = UITableView(frame: .zero, style: .grouped)
    private let tableBackgroundView = UIView()
    private let tableViewBackgroundView = TableViewBackgroundView()
    private let confirmButton = UIButton(configuration: .primary(title: "Add"))
    private let cancelButton = UIButton(configuration: .secondary(title: "Cancel"))
    private let addNewGroupButton = UIButton(configuration: .clear(title: "+ Add new group"))
    
    private var contact = ContactCardModel(name: "", email: "", date: Date())
    private var groups = [ContactGroup(name: "")]
    
    let confirmButtonTitle: String
    
    weak var delegate: CreateContactViewDelegate?
    weak var sizeDelegate: PreferredContentSizeUpdatable?
    
    init(contact: ContactCardModel?, groups: [ContactGroup]) {
        self.groups = groups
        if let contact {
            self.contact = contact
            self.confirmButtonTitle = "Save"
        } else {
            self.contact = ContactCardModel(name: "", email: "", date: Date())
            self.confirmButtonTitle = "Add"
        }
        super.init()
        
        setupContactView()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        contactNameTextField.delegate = self
        contactEmailTextField.delegate = self
        
        tableBackgroundView.backgroundColor = .dark10
        tableBackgroundView.layer.cornerRadius = 12
        
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        groupsTableView.register(SelectGroupCell.self)
        groupsTableView.backgroundView = tableViewBackgroundView
        groupsTableView.separatorStyle = .none
        groupsTableView.backgroundColor = .dark10
        
        addGroupControl.text = contact.groups.map(\.name).joined(separator: ", ")
        
        addNewGroupButton.addTarget(self, action: #selector(didTouchAddGroupButton), for: .touchUpInside)
        
        confirmButton.IVsetEnabled(false, title: confirmButtonTitle)
        confirmButton.addTarget(self, action: #selector(didTouchSaveButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTouchCancelButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            addContactHeader,
            contactNameTextField,
            contactEmailTextField,
            addGroupControl,
            tableBackgroundView,
            confirmButton,
            cancelButton
        ].forEach(addSubview)
        
        
        tableBackgroundView.addSubview(groupsTableView)
        tableBackgroundView.addSubview(addNewGroupButton)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        addContactHeader.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), excludingEdge: .bottom)
        
        contactNameTextField.autoPinEdge(.top, to: .bottom, of: addContactHeader, withOffset: 24)
        contactNameTextField.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        contactNameTextField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        
        contactEmailTextField.autoPinEdge(.top, to: .bottom, of: contactNameTextField, withOffset: 12)
        contactEmailTextField.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        contactEmailTextField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        
        addGroupControl.autoPinEdge(.top, to: .bottom, of: contactEmailTextField, withOffset: 16)
        addGroupControl.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        addGroupControl.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        
        tableBackgroundView.autoPinEdge(.top, to: .bottom, of: addGroupControl, withOffset: 8)
        tableBackgroundView.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        tableBackgroundView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        
        groupsTableView.autoMatch(.height, to: .width, of: groupsTableView, withMultiplier: 0.8)
        groupsTableView.autoPinEdge(toSuperviewEdge: .top, withInset: 4)
        groupsTableView.autoPinEdge(toSuperviewEdge: .leading)
        groupsTableView.autoPinEdge(toSuperviewEdge: .trailing)
        
        addNewGroupButton.autoPinEdge(.top, to: .bottom, of: groupsTableView, withOffset: 8)
        addNewGroupButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        addNewGroupButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        addNewGroupButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 4)
        
        confirmButton.autoPinEdge(.top, to: .bottom, of: addNewGroupButton, withOffset: 8)
        confirmButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        confirmButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        
        cancelButton.autoPinEdge(.top, to: .bottom, of: confirmButton, withOffset: 8)
        cancelButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
        cancelButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 24)
        cancelButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 24)
    }
    
    @objc private func didTouchSaveButton(_ sender: UIButton) {
//        delegate?.didCreateGroup(group, contacts: contacts)
    }
    
    @objc private func didTouchCancelButton(_ sender: UIButton) {
        delegate?.didTouchCancel()
    }
    
    @objc private func didTouchAddGroupButton(_ sender: UIButton) {
        delegate?.createNewGroup(view: self)
    }
    
    private func setupContactView() {
        contactNameTextField.text = contact.name
        contactEmailTextField.text = contact.email
        addGroupControl.text = contact.groups.map(\.name).joined(separator: ", ")
    }
    
    private func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }
}

extension CreateContactView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = groups.count != 0
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SelectGroupCell.self, for: indexPath)
        let group = groups[indexPath.row]
        let isSelected = group.members.contains(contact)
        
        cell.configure(with: group, isSelected: isSelected)
        cell.delegate = self
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

extension CreateContactView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectGroupCell else { return }
        
        let group = groups[indexPath.row]
        if cell.isAdded {
            group.removeMember(by: contact.id)
        } else {
            group.addMember(contact)
        }
        addGroupControl.text = contact.groups.map(\.name).joined(separator: ", ")
        groupsTableView.reloadData()
    }
}

extension CreateContactView: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        guard let name = contactNameTextField.text,
              let email = contactEmailTextField.text
        else { return }
        
        let isValid = contactNameTextField.isValid && contactEmailTextField.isValid
        
        confirmButton.IVsetEnabled(isValid, title: confirmButtonTitle)
    }
}

extension CreateContactView: SelectGroupCellDelegate {
    func selectGroupCellDidTapEdit(_ cell: SelectGroupCell) {
        guard let indexPath = groupsTableView.indexPath(for: cell) else {
            return
        }
        let group = groups[indexPath.row]
        delegate?.selectGroupCellDidTapEdit(group: group)    }
    
    func selectGroupCellDidTapDelete(_ cell: SelectGroupCell) {
        guard let indexPath = groupsTableView.indexPath(for: cell) else {
            return
        }
        let group = groups[indexPath.row]
        delegate?.selectGroupCellDidTapDelete(group: group)
    }
}
