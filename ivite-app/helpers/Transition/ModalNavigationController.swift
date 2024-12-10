//
//  ModalNavigationController.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 14/11/2024.
//


import UIKit

class ModalNavigationController: UINavigationController {
    var isFullScreen: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
        view.backgroundColor = .clear 
        // Configure the sheet presentation controller if available
        if let sheet = sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    // Use maximum detent if full screen
                    guard !self.isFullScreen else { return context.maximumDetentValue }
                    
                    // If the root view controller conforms to ContentSizeProvider, use its content size
                    if let provider = self.topViewController as? ContentSizeProvider {
                        return provider.contentSize(for: context.maximumDetentValue).height
                    }
                    
                    // Fallback to maximum height if ContentSizeProvider is not available
                    return context.maximumDetentValue
                })
            ]
            
            sheet.largestUndimmedDetentIdentifier = nil
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Invalidate detents in case of layout changes
        (presentationController as? UISheetPresentationController)?.invalidateDetents()
    }
}
