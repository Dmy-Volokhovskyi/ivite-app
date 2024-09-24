import UIKit
import PureLayout

protocol LaunchEventHandler: AnyObject {
    func viewDidLoad()
}

protocol LaunchDataSource: AnyObject {
}

final class LaunchController: BaseViewController {
    private let eventHandler: LaunchEventHandler
    private let dataSource: LaunchDataSource
    
    private let testLabel = UILabel()

    init(eventHandler: LaunchEventHandler, dataSource: LaunchDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHandler.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        
        testLabel.text = "HELLO!"
        
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

extension LaunchController: LaunchViewInterface {
}
