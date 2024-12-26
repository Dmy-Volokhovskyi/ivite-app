//
//  LoadingButton.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 15/12/2024.
//

import UIKit

final class IVButton: UIButton {
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var originalConfiguration: UIButton.Configuration?
    private var isLoading: Bool = false
    private var title: String
    
    init(configuration: UIButton.Configuration, title: String) {
        self.title = title
        super.init(frame: .zero)
        self.originalConfiguration = configuration
        self.configuration = configuration
      
        setupActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupActivityIndicator() {
        addSubview(activityIndicator)
        
        activityIndicator.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
        activityIndicator.autoPinEdge(toSuperviewEdge: .bottom, withInset: 12)
        activityIndicator.autoAlignAxis(toSuperviewAxis: .vertical)
    }

    func showLoading() {
        guard !isLoading else { return }
        isLoading = true
        
        var loadingConfig = self.configuration
        loadingConfig?.title = nil
        loadingConfig?.image = nil
        self.configuration = loadingConfig
        
        activityIndicator.startAnimating()
        isUserInteractionEnabled = false
    }
    @MainActor
    func hideLoading() {
        guard isLoading else { return }
        isLoading = false

        if !isUserInteractionEnabled {
            Idisable()
        } else if let originalConfig = originalConfiguration {
            self.configuration = originalConfig
        }
        
        activityIndicator.stopAnimating()
    }
    @MainActor
    func Idisable() {
        let disabledConfig = UIButton.Configuration.disabledPrimary(title: title)
        self.configuration = disabledConfig
        self.isUserInteractionEnabled = false
    }
    @MainActor
    func Ienable() {
        if let originalConfig = originalConfiguration {
            self.configuration = originalConfig
            
        }
        self.isUserInteractionEnabled = true
    }

    func IVsetEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            if enabled {
                self.Ienable()
            } else {
                self.Idisable()
            }
        }
    }
}


