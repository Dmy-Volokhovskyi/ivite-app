//
//  EditContactView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 27/01/2025.
//

import UIKit

protocol EditContactViewDelegate: AnyObject {
    func editContactView(_ view: EditContactView, requestSave contact: ContactCardModel)
    func editContactViewDidCancel(_ view: EditContactView)
    func editContactView(_ view: EditContactView, requestCreateNewGroupFor contact: ContactCardModel)
    func editContactView(_ view: EditContactView, requestEdit group: ContactGroup, for contact: ContactCardModel)
    func editContactView(_ view: EditContactView, requestDeleteGroup group: ContactGroup)
}


final class EditContactView: BaseView {
    private let editContactHeader: IVHeaderLabel = .init(text: "Edit contact")
    private let contactNameTextField = IVTextField(placeholder: "Name", leadingImage: .person)
    private let contactEmailTextField = IVTextField(placeholder: "Email contact", leadingImage: .email, validationType: .email)
    private let addGroupControl = IVControl(placeholder: "Add new group", leadingImage: .group, trailingImage: .chewronDown)
    private let groupsTableView = UITableView(frame: .zero, style: .grouped)
    private let tableBackgroundView = UIView()
    private let tableViewBackgroundView = TableViewBackgroundView()
    private let confirmButton = UIButton(configuration: .primary(title: "Save"))
    private let cancelButton = UIButton(configuration: .secondary(title: "Cancel"))
    private let addNewGroupButton = UIButton(configuration: .clear(title: "+ Add new group"))
    
    private var contact: ContactCardModel
    private var groups: [ContactGroup]
    
    
    weak var delegate: EditContactViewDelegate?
    weak var sizeDelegate: PreferredContentSizeUpdatable?
    
    init(contact: ContactCardModel, groups: [ContactGroup]) {
        self.groups = groups
        self.contact = contact
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
        
        addGroupControl.text = groups
            .filter { contact.groupIds.contains($0.id) }
            .map(\.name)
            .joined(separator: ", ")
        
        addNewGroupButton.addTarget(self, action: #selector(didTouchAddGroupButton), for: .touchUpInside)
        
        confirmButton.IVsetEnabled(false, title: "Save")
        confirmButton.addTarget(self, action: #selector(didTouchSaveButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTouchCancelButton), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            editContactHeader,
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
        
        editContactHeader.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), excludingEdge: .bottom)
        
        contactNameTextField.autoPinEdge(.top, to: .bottom, of: editContactHeader, withOffset: 24)
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
        delegate?.editContactView(self, requestSave: contact)
    }
    
    @objc private func didTouchCancelButton(_ sender: UIButton) {
        delegate?.editContactViewDidCancel(self)
    }
    
    @objc private func didTouchAddGroupButton(_ sender: UIButton) {
        delegate?.editContactView(self, requestCreateNewGroupFor: contact)
    }
    
    private func setupContactView() {
        contactNameTextField.text = contact.name
        contactEmailTextField.text = contact.email
        addGroupControl.text = groups
            .filter { contact.groupIds.contains($0.id) }
            .map(\.name)
            .joined(separator: ", ")
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

extension EditContactView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = groups.count != 0
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SelectGroupCell.self, for: indexPath)
        let group = groups[indexPath.row]
        let isSelected = contact.groupIds.contains(group.id)
        
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

extension EditContactView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectGroupCell else { return }
        
        let group = groups[indexPath.row]
        if cell.isAdded {
            group.removeMember(by: contact.id)
        } else {
            group.addMember(contact)
        }
        
        addGroupControl.text = groups
            .filter { contact.groupIds.contains($0.id) } // Filter groups by IDs in contact.groupIds
            .map(\.name) // Extract the names of matching groups
            .joined(separator: ", ") // Combine names into a single string
        
        groupsTableView.reloadData()
    }
}

extension EditContactView: IVTextFieldDelegate {
    func textFieldDidChange(_ textField: IVTextField) {
        guard let name = contactNameTextField.text,
              let email = contactEmailTextField.text
        else { return }
        
        contact.name = name
        contact.email = email
        
        let isValid = contactNameTextField.isValid && contactEmailTextField.isValid
        
        confirmButton.IVsetEnabled(isValid, title: "Save")
    }
}

extension EditContactView: SelectGroupCellDelegate {
    func selectGroupCellDidTapEdit(_ cell: SelectGroupCell) {
        guard let indexPath = groupsTableView.indexPath(for: cell) else {
            return
        }
        let group = groups[indexPath.row]
        delegate?.editContactView(self, requestEdit: group, for: contact)
    }
    
    func selectGroupCellDidTapDelete(_ cell: SelectGroupCell) {
        guard let indexPath = groupsTableView.indexPath(for: cell) else {
            return
        }
        let group = groups[indexPath.row]
        delegate?.editContactView(self, requestDeleteGroup: group)
    }
}
