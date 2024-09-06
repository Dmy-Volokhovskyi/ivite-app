import UIKit

protocol ContactEventHandler: AnyObject {
}

protocol ContactDataSource: AnyObject {
}

final class ContactController: BaseViewController {
    private let eventHandler: ContactEventHandler
    private let dataSource: ContactDataSource
    
    private let searchBarView = MainSearchBarView()
    private let listHeaderView = ListHeaderView(actionButton: UIButton(configuration: .primary(title: "Add New", image: .chewronDown)), title: "Contact List")
    private let invitesLeftView = InvitesLeftView()
    
    init(eventHandler: ContactEventHandler, dataSource: ContactDataSource) {
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
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            searchBarView,
            listHeaderView,
            invitesLeftView
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
    }
}

extension ContactController: ContactViewInterface {
}
