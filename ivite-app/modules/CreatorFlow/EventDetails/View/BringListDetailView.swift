//
//  BringListDetailView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 14/10/2024.
//

import UIKit

protocol BringListDetailViewDelegate: AnyObject {
    func bringListDetailView(_ view: BringListDetailView, requestDeleteItem item: BringListItem)
}

final class BringListDetailView: BaseView {
    private var model: EventDetailsViewModel
    private let bringListHeader = IVHeaderLabel(text: "Bring List")
    private let bringListActiveSwitch = UISwitch()
    private let bringItemsStack = UIStackView()
    private let addAnotherItemButton = UIButton(configuration: .clear(title: "+ Add another item"))
    
    weak var delegate: BringListDetailViewDelegate?
    
    init(model: EventDetailsViewModel) {
        self.model = model
        super.init(frame: .zero)
        
        bringListActiveSwitch.isOn = model.isBringListActive
        addAnotherItemButton.isHidden = !model.isBringListActive
        fillBringItems(with: bringListActiveSwitch.isOn ? model.bringList : [])
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        bringItemsStack.axis = .vertical
        bringItemsStack.spacing = 6
        
        bringListActiveSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        addAnotherItemButton.addTarget(self, action: #selector(addAnotherItemButtonTapped), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            bringListHeader,
            bringListActiveSwitch,
            bringItemsStack
        ].forEach(addSubview)
        
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        bringListHeader.autoPinEdge(toSuperviewEdge: .top)
        bringListHeader.autoPinEdge(toSuperviewEdge: .leading)
        
        bringListActiveSwitch.autoPinEdge(.leading, to: .trailing, of: bringListHeader)
        bringListActiveSwitch.autoPinEdge(toSuperviewEdge: .top)
        bringListActiveSwitch.autoPinEdge(toSuperviewEdge: .trailing)
        
        bringItemsStack.autoPinEdge(.top, to: .bottom, of: bringListHeader, withOffset: 16)
        bringItemsStack.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    private func fillBringItems(with bringItems: [BringListItem]) {
        bringItemsStack.subviews.forEach({ $0.removeFromSuperview()} )
        
        let bringItemsViews: [BringListItemView] = bringItems.map(\.self).map(BringListItemView.init)
        bringItemsViews.forEach({ item in
            bringItemsStack.addArrangedSubview(item)
            item.delegate = self
        })
        bringItemsStack.addArrangedSubview(addAnotherItemButton)
    }
    
    func updateModel(with model: EventDetailsViewModel) {
        self.model = model
        fillBringItems(with: model.bringList)
    }
    
    @objc private func addAnotherItemButtonTapped(_ sender: UIButton) {
        model.bringList.append(BringListItem())
        fillBringItems(with: model.bringList)
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        model.isBringListActive.toggle()
        addAnotherItemButton.isHidden = !model.isBringListActive
        fillBringItems(with: sender.isOn ? model.bringList : [])
    }
}

extension BringListDetailView: BringListItemViewDelegate {
    func didUpdateBringListItem(_ view: BringListItemView, for id: String, with model: BringListItem) {
        guard let item = self.model.bringList.firstIndex(where: { $0.id == id } ) else { return }
        self.model.bringList[item] = model
    }
    
    func bringListItemViewDidTapDeleteButton(_ view: BringListItemView, for id: String) {
        guard let item = model.bringList.first(where: { $0.id == id } ) else { return }
        
        delegate?.bringListDetailView(self, requestDeleteItem: item)
    }
}
