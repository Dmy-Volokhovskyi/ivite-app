//
//  DownloadableImageView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 05/10/2024.
//

import UIKit
import Photos

class DownloadableImageView: UIView {
    
    private let imageView = UIImageView()
    private let dimView = UIView()
    private let downloadButton = UIButton(configuration: .filled())
    private let userImageLibraryManager = UserImageLibraryManager()
    
    init(image: UIImage?) {
        super.init(frame: .zero)
        setupView()
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Set up the imageView
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        // Set up the dim view
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimView.isUserInteractionEnabled = false
        
        // Set up the download button
        downloadButton.setTitle("Download Image", for: .normal)
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        
        // Add subviews
        addSubview(imageView)
        addSubview(dimView)
        addSubview(downloadButton)
        
        // Apply constraints using the library you use
        imageView.autoPinEdgesToSuperviewEdges()
        dimView.autoPinEdgesToSuperviewEdges()
        
        downloadButton.autoAlignAxis(toSuperviewAxis: .vertical)
        downloadButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
    }
    
    @objc private func downloadButtonTapped() {
        userImageLibraryManager.requestAccessIfNeeded { [weak self] granted in
            guard granted, let image = self?.imageView.image else { return }
            self?.saveImageToLibrary(image)
        }
    }
    
    private func saveImageToLibrary(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        print("Image saved to library")
    }
}
