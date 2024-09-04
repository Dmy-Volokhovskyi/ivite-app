import UIKit

protocol EventsEventHandler: AnyObject {
}

protocol EventsDataSource: AnyObject {
}

final class EventsController: BaseViewController {
    private let eventHandler: EventsEventHandler
    private let dataSource: EventsDataSource
    
    private let testLabel = UILabel()

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
        
        testLabel.text = "Events!"
        
        testLabel.textColor = .red
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        view.addSubview(testLabel)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        testLabel.autoPinEdgesToSuperviewEdges()
    }
}

extension EventsController: EventsViewInterface {
}
