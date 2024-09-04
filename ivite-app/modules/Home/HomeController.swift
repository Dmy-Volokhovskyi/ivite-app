import UIKit

protocol HomeEventHandler: AnyObject {
}

protocol HomeDataSource: AnyObject {
}

final class HomeController: BaseViewController {
    private let eventHandler: HomeEventHandler
    private let dataSource: HomeDataSource

    private let testLabel = UILabel()
    init(eventHandler: HomeEventHandler, dataSource: HomeDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        testLabel.text = "HOME!"
        
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

extension HomeController: HomeViewInterface {
}
