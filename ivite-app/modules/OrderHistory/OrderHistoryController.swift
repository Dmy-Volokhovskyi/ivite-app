import UIKit

protocol OrderHistoryEventHandler: AnyObject {
    func viewWillAppear()
}

protocol OrderHistoryDataSource: AnyObject {
}

final class OrderHistoryController: BaseScrollViewController {
    private let eventHandler: OrderHistoryEventHandler
    private let dataSource: OrderHistoryDataSource
    
    private let backButton = UIButton(configuration: .image(image: .chewroneBack))
    private let titleLabel = UILabel()

    init(eventHandler: OrderHistoryEventHandler, dataSource: OrderHistoryDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        titleLabel.text = "Ordet History"
        titleLabel.font = .interFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .secondary1
        
        backButton.addTarget(self, action: #selector(didTouchBack), for: .touchUpInside)
        view.backgroundColor = .white
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            backButton,
            titleLabel
        ].forEach({ contentView.addSubview($0) })
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        backButton.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        backButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        titleLabel.autoPinEdge(.leading, to: .trailing, of: backButton, withOffset: 16)
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: backButton)
    }
    
    private func setUpmainDetailsContainerConstraints() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventHandler.viewWillAppear()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc private func didTouchBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension OrderHistoryController: OrderHistoryViewInterface {
}
