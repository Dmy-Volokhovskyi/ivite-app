import UIKit

protocol OrderHistoryEventHandler: AnyObject {
    func viewWillAppear()
}

protocol OrderHistoryDataSource: AnyObject {
    var numberOfRows: Int { get }
}

final class OrderHistoryController: BaseViewController {
    private let eventHandler: OrderHistoryEventHandler
    private let dataSource: OrderHistoryDataSource
    
    private let backButton = UIButton(configuration: .image(image: .chewroneBack))
    private let titleLabel = UILabel()
    
    private let orderHistoryBackgroundView = UIView()
    private let orderHistoryLabel = UILabel()
    private let tableView = UITableView()
    private let tableViewBackgroundView = TableViewBackgroundView()

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
        
        titleLabel.text = "Order History"
        titleLabel.font = .interFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .secondary1
        
        backButton.addTarget(self, action: #selector(didTouchBack), for: .touchUpInside)
        
        orderHistoryBackgroundView.layer.cornerRadius = 14
        orderHistoryBackgroundView.backgroundColor = .dark10
        
        orderHistoryLabel.text = "Order History"
        orderHistoryLabel.textColor = .secondary1
        orderHistoryLabel.font = .interFont(ofSize: 24, weight: .bold)
        
        tableView.backgroundColor = .dark10
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(OrderHistoryCell.self)
        tableView.backgroundView = tableViewBackgroundView
        
        tableViewBackgroundView.configure(text: "Your order history is empty", image: .file2)
        
        view.backgroundColor = .white
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            backButton,
            titleLabel,
            orderHistoryBackgroundView
        ].forEach({ view.addSubview($0) })
        
        orderHistoryBackgroundView.addSubview(orderHistoryLabel)
        orderHistoryBackgroundView.addSubview(tableView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        backButton.autoPinEdge(toSuperviewSafeArea: .top, withInset: 8)
        backButton.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 16)
        
        titleLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 8)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 16)
        titleLabel.autoPinEdge(.leading, to: .trailing, of: backButton, withOffset: 16)
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: backButton)
        
        orderHistoryBackgroundView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 24)
        orderHistoryBackgroundView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16), excludingEdge: .top)
        
        orderHistoryLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16), excludingEdge: .bottom)
        
        tableView.autoPinEdge(.top, to: .bottom, of: orderHistoryLabel, withOffset: 16)
        tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16), excludingEdge: .top)
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

extension OrderHistoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = dataSource.numberOfRows != 0
        return dataSource.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(OrderHistoryCell.self, for: indexPath)
        let order = OrderHistoryItem(product: "Premium subscription",
                                     date: "21/01/2024",
                                     price: "39.99$",
                                     status: "Success",
                                     isSuccess: true)
        cell.configure(with: order)
        return cell
    }
    
    
}

extension OrderHistoryController: UITableViewDelegate {
    
}
