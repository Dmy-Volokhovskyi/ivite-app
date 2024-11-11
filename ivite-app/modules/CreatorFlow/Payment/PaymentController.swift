import UIKit

protocol PaymentEventHandler: AnyObject {
    func didSelectOption(at indexPath: IndexPath)
    func didTouchBackButton()
    func didTouchNextButton()
}

protocol PaymentDataSource: AnyObject {
    var paymentOptions: [PaymentOption] { get }
    var selectedOption: PaymentOption? { get }
}

final class PaymentController: BaseViewController {
    private let eventHandler: PaymentEventHandler
    private let dataSource: PaymentDataSource
    
    private let paymentHeader = IVHeaderLabel(text: "Payment")
    private let paymentOptionsTableView = UITableView(frame: .zero, style: .grouped)
    
    private let bottomBarView = UIView()
    private let bottomDividerView = DividerView()
    private let backButton = UIButton(configuration: .image(image: .chewroneBack))
    private let nextButton = UIButton(configuration: .primary(title: "Purchase&Send"))
    
    init(eventHandler: PaymentEventHandler, dataSource: PaymentDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        bottomBarView.backgroundColor = .white
        view.backgroundColor = .paymentBackground
        
        paymentOptionsTableView.backgroundColor = UIColor.clear
        paymentOptionsTableView.separatorStyle = .none
        
        backButton.addTarget(self, action: #selector(didTouchBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTouchNextButton), for: .touchUpInside)
        
        setupTableView()
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        bottomBarView.addSubview(bottomDividerView)
        bottomBarView.addSubview(backButton)
        bottomBarView.addSubview(nextButton)
        
        view.addSubview(bottomBarView)
        view.addSubview(paymentHeader)
        view.addSubview(paymentOptionsTableView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        paymentHeader.autoPinEdge(toSuperviewSafeArea: .top, withInset: 24)
        paymentHeader.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        paymentHeader.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        paymentOptionsTableView.autoPinEdge(.top, to: .bottom, of: paymentHeader, withOffset: 6)
        paymentOptionsTableView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        paymentOptionsTableView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        bottomBarView.autoPinEdge(.top, to: .bottom, of: paymentOptionsTableView)
        bottomBarView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        
        setUpBottomViewConstraints()
    }
    
    private func setupTableView() {
        paymentOptionsTableView.register(PaymentOptionCell.self)
        paymentOptionsTableView.dataSource = self
        paymentOptionsTableView.delegate = self
    }
    
    private func setUpBottomViewConstraints() {
        bottomDividerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        backButton.autoPinEdge(.top, to: .bottom, of: bottomDividerView, withOffset: 24)
        
        backButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        backButton.autoPinEdge(.trailing, to: .leading, of: nextButton, withOffset: -12)
        backButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 8)
        backButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        backButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        nextButton.autoPinEdge(.top, to: .bottom, of: bottomDividerView, withOffset: 24)
        nextButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        nextButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 8)
        
        nextButton.setContentHuggingPriority(.init(1), for: .horizontal)
        nextButton.setContentCompressionResistancePriority(.init(1), for: .horizontal)
    }
    
    @objc private func didTouchBackButton(_ sender: UIButton) {
        eventHandler.didTouchBackButton()
    }
    
    @objc private func didTouchNextButton(_ sender: UIButton) {
        eventHandler.didTouchNextButton()
    }
}

extension PaymentController: PaymentViewInterface {
    func reload() {
        paymentOptionsTableView.reloadData()
    }
}

extension PaymentController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(PaymentOptionCell.self, for: indexPath)
        let option = dataSource.paymentOptions[indexPath.row]
        let isSelected = option == dataSource.selectedOption
        
        cell.configure(paymentOption: option, isSelected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.paymentOptions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventHandler.didSelectOption(at: indexPath)
    }
}
