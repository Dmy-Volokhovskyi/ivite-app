import UIKit

protocol EventsEventHandler: AnyObject {
}

protocol EventsDataSource: AnyObject {
}

final class EventsController: BaseViewController {
    private let eventHandler: EventsEventHandler
    private let dataSource: EventsDataSource
    
    private let searchBarView = MainSearchBarView()
    private let listHeaderView = ListHeaderView(actionButton: UIButton(configuration: .primary(title: "Create New Event", image: nil)), title: "Event List")
    private let invitesLeftView = InvitesLeftView()
    
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

extension EventsController: EventsViewInterface {
}
