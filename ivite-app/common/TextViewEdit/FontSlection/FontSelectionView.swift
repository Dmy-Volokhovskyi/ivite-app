//
//  FontSelectionView.swift
//  ivite-app
//
//  Created by Max Volokhovskyi on 25/09/2024.
//

import UIKit
import PureLayout

protocol FontSelectionDelegate: AnyObject {
    func fontSelectionViewDidSelectFont(_fontSelectionView: FontSelectionView, fontName: String)
    func fontSelectionViewDidResetSelection(_fontSelectionView: FontSelectionView)
}

class FontSelectionView: BaseView {
    private let resetButton = UIButton(configuration: .secondary(title: "Reset"))
    private let closeButton = UIButton(configuration: .secondary(title: "Close"))
    private let tableView = UITableView()
    private var fontFamilies: [String] = []
    private var recommendedFonts: [String]
    private var selectedFont: String?
    
    weak var delegate: FontSelectionDelegate?
    
    // Initialize with optional recommended fonts
    init(recommendedFonts: [String] = ["Helvetica", "Arial", "Courier"], seletedFont: String?) {
        self.recommendedFonts = recommendedFonts
        self.selectedFont = seletedFont
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.recommendedFonts = ["Helvetica", "Arial", "Courier"]
        super.init(coder: coder)
    }
    
    override func setupView() {
        super.setupView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FontTableViewCell.self)
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        backgroundColor = .white // For demonstration, set a background color.
        fontFamilies = UIFont.familyNames.sorted() // Get all available font families
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        [
            closeButton,
            resetButton,
            tableView
        ].forEach(addSubview)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        resetButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        resetButton.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        
        closeButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        closeButton.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        closeButton.autoMatch(.height, to: .height, of: resetButton)
        
        tableView.autoPinEdge(.top, to: .bottom, of: closeButton, withOffset: 8)
        tableView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    @objc private func resetButtonTapped() {
        delegate?.fontSelectionViewDidResetSelection(_fontSelectionView: self)
    }
    
    @objc private func closeButtonTapped() {
        // Handle close action (hide or remove the picker view)
        self.isHidden.toggle() // Example: Removing the view when closed
    }
}
    // MARK: - UITableViewDataSource
    extension FontSelectionView: UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 2 // Section 0 for Recommended Fonts, Section 1 for All Fonts
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return section == 0 ? recommendedFonts.count : fontFamilies.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(FontTableViewCell.self, for: indexPath)
            
            // Display recommended fonts in section 0, and all fonts in section 1
            let fontName = indexPath.section == 0 ? recommendedFonts[indexPath.row] : fontFamilies[indexPath.row]
            let isSelected = fontName == selectedFont
            cell.configure(with: fontName, isSelected: isSelected)
            return cell
        }
    }
   
    // MARK: - UITableViewDelegate
extension FontSelectionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fontName = indexPath.section == 0 ? recommendedFonts[indexPath.row] : fontFamilies[indexPath.row]
        delegate?.fontSelectionViewDidSelectFont(_fontSelectionView: self, fontName: fontName)
    }
}
 
