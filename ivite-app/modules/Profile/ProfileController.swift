import UIKit

protocol ProfileEventHandler: AnyObject {
}

protocol ProfileDataSource: AnyObject {
}

final class ProfileController: BaseViewController, UIScrollViewDelegate {
    private let eventHandler: ProfileEventHandler
    private let dataSource: ProfileDataSource
    
    private let zoomButton = UIButton(type: .system)
    
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
        
    }
    
    override func addSubviews() {
        super.addSubviews()

        view.addSubview(zoomButton)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        zoomButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 250)
        zoomButton.autoAlignAxis(toSuperviewAxis: .vertical)
    }
}

extension ProfileController: ProfileViewInterface {
}

