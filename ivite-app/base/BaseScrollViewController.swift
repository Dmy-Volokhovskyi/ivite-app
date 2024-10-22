//
//  BaseScrollViewController.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 11/10/2024.
//

import UIKit
import PureLayout

class BaseScrollViewController: BaseViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private var bottomInset: CGFloat = 0
    
    override func setupView() {
        super.setupView()
        
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        scrollView.addSubview(contentView)
        
        view.addSubview(scrollView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        contentView.autoPinEdgesToSuperviewEdges()
        contentView.autoMatch(.width, to: .width, of: view)
        
        scrollView.autoPinEdgesToSuperviewEdges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setBottomInset(inset: CGFloat) {
        bottomInset = inset
        scrollView.contentInset.bottom = bottomInset
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.contentInset.bottom = keyboardSize.height - view.safeAreaInsets.bottom
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardSize.height - view.safeAreaInsets.bottom
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = bottomInset
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
    }
}

extension BaseScrollViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
