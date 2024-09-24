//
//  CategoriesCollectionView.swift
//  ivite-app
//
//  Created by GoApps Developer on 06/09/2024.
//
import UIKit
import PureLayout
import Reusable

class CategoriesCollectionView: BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var categories: [String]
    private var selectedCategory: String?
    let layout = CenteredCollectionViewFlowLayout()
    var collectionHeightConstraint: NSLayoutConstraint?
    
    private lazy var collectionView: UICollectionView = {
        let layout = layout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self)
        return collectionView
    }()
    
    init(categories: [String]) {
        self.categories = categories
        super.init(frame: .zero)
        setupView()
        updateCollectionViewHeight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func setupView() {
        addSubviews()
        constrainSubviews()
    }
    
    override func addSubviews() {
        addSubview(collectionView)
    }
    
    override func constrainSubviews() {
        collectionView.autoPinEdgesToSuperviewEdges()
        collectionHeightConstraint = collectionView.autoSetDimension(.height, toSize: 0)
        collectionHeightConstraint?.isActive = false
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(CategoryCell.self, for: indexPath)
        let category = categories[indexPath.item]
        let isSelected = category == selectedCategory
        cell.configure(with: category, isSelected: isSelected)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        selectedCategory = selectedCategory == category ? nil : category
        collectionView.reloadData()
        updateCollectionViewHeight()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = CategoryCell()
        cell.configure(with: categories[indexPath.item], isSelected: false)
        
        // Calculate size using systemLayoutSizeFitting
        let targetSize = CGSize(width: collectionView.bounds.width, height: 40)
        let fittingSize = cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultLow, verticalFittingPriority: .required)
        let maxWidth = collectionView.bounds.width - 40
        let width = min(fittingSize.width, maxWidth)
        
        return CGSize(width: width, height: 40)
    }
    
    // MARK: - Helper Methods
    
    private func updateCollectionViewHeight() {
        layout.invalidateLayout() // Invalidate layout to get the correct number of rows
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Trigger layout pass to calculate the number of rows
            self.collectionView.layoutIfNeeded()
            
            // Calculate the height needed
            let contentHeight = self.collectionView.contentSize.height
            
            // Update the height constraint
            self.collectionHeightConstraint?.constant = contentHeight
            collectionHeightConstraint?.isActive = true
            self.layoutIfNeeded()
        }
    }
}


import UIKit
import PureLayout

class CategoryCell: BaseUICollectionViewItem {
    private let titleLabel = UILabel()
    

    override func setupCell() {
        super.setupCell()
        
        titleLabel.font = .interFont(ofSize: 14, weight: .bold)
    }
    
    override func addSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    
    override func constrainSubviews() {
        titleLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        contentView.backgroundColor = .primaryLight10
    }
    
    func configure(with text: String, isSelected: Bool) {
        titleLabel.text = text
        contentView.backgroundColor = isSelected ? .accent : .primaryLight10
        titleLabel.textColor = isSelected ? .white : .accent
        contentView.layer.cornerRadius = 20
    }
    
    
}

class CenteredCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        let attributesCopy = attributes.map { $0.copy() as! UICollectionViewLayoutAttributes }
        
        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0
        var rowAttributes: [UICollectionViewLayoutAttributes] = []
        
        attributesCopy.forEach { layoutAttribute in
            // Check if item is in a new row
            if layoutAttribute.frame.origin.y >= maxY {
                // Center previous row items
                centerRowAttributes(rowAttributes)
                // Start new row
                rowAttributes.removeAll()
                leftMargin = sectionInset.left
            }
            
            // Add current item to row
            layoutAttribute.frame.origin.x = leftMargin
            rowAttributes.append(layoutAttribute)
            
            // Update left margin and maxY
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        // Center last row
        centerRowAttributes(rowAttributes)
        
        return attributesCopy
    }
    
    private func centerRowAttributes(_ rowAttributes: [UICollectionViewLayoutAttributes]) {
        guard !rowAttributes.isEmpty else { return }
        // Calculate the total width of the row
        let totalRowWidth = rowAttributes.reduce(0) { $0 + $1.frame.width } + CGFloat(rowAttributes.count - 1) * minimumInteritemSpacing
        
        // Calculate the padding to center the row
        let padding = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - totalRowWidth) / 2
        
        // Adjust each item's x position to center the row
        var offset = sectionInset.left + max(padding, 0)
        rowAttributes.forEach { layoutAttribute in
            layoutAttribute.frame.origin.x = offset
            offset += layoutAttribute.frame.width + minimumInteritemSpacing
        }
    }
}
