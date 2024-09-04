import UIKit

protocol ContactEventHandler: AnyObject {
}

protocol ContactDataSource: AnyObject {
}

final class ContactController: BaseViewController {
    private let eventHandler: ContactEventHandler
    private let dataSource: ContactDataSource
    
    private let testLabel = UILabel()

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
        
        testLabel.text = "CONTACT!"
        
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

extension ContactController: ContactViewInterface {
}
