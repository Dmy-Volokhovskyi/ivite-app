//
//  BringListDetailView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 14/10/2024.
//

import UIKit

protocol BringListDetailViewDelegate: AnyObject {
    func bringListDetailView(_ view: BringListDetailView, didUpdateIsBringListActive isActive: Bool)
    func bringListDetailView(_ view: BringListDetailView, didAddItem item: BringListItem)
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
        bringListActiveSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
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
        bringItemsViews.forEach(bringItemsStack.addArrangedSubview)
        bringItemsStack.addArrangedSubview(addAnotherItemButton)
    }
    
    @objc private func addAnotherItemButtonTapped(_ sender: UIButton) {
        delegate?.bringListDetailView(self, didAddItem: BringListItem())
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        model.isBringListActive.toggle()
        addAnotherItemButton.isHidden = !model.isBringListActive
        fillBringItems(with: sender.isOn ? model.bringList : [])
    }
}

extension BringListDetailView: BringListItemViewDelegate {
    func bringListItemViewDidTapDeleteButton(_ view: BringListItemView, for id: String) {
        guard let item = model.bringList.first(where: { $0.id == id } ) else { return }
        
        delegate?.bringListDetailView(self, requestDeleteItem: item)
    }
}
