import UIKit

protocol ProfileEventHandler: AnyObject {
}

protocol ProfileDataSource: AnyObject {
}

final class ProfileController: BaseViewController {
    private let eventHandler: ProfileEventHandler
    private let dataSource: ProfileDataSource
    
    private let testLabel = UILabel()

    init(eventHandler: ProfileEventHandler, dataSource: ProfileDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupView() {
        super.setupView()
        
        testLabel.text = "PROFILE!"
        
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

extension ProfileController: ProfileViewInterface {
}
