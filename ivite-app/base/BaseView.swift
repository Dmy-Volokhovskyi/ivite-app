//
//  BaseView.swift
//  ivite-app
//
//  Created by GoApps Developer on 01/09/2024.
//

import UIKit

class BaseView: UIView {
    init() {
        super.init(frame: .zero)
        viewDidLoad()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewDidLoad()
    }
    
    private func viewDidLoad() {
        setupView()
        addSubviews()
        constrainSubviews()
    }
    
    func setupView() { }
    func addSubviews() { }
    func constrainSubviews() { }
}

//final class ReviewMainDetailView: BaseView {
//   override func setupView() {
//       super.setupView()
//       
//   }
//    
//   override func addSubviews() {
//       super.addSubviews()
//       
//   }
//    
//   override func constrainSubviews() {
//       super.constrainSubviews()
//       
//   }
//}
