import UIKit

protocol HomeEventHandler: AnyObject {
    func didSelectItem(at indexPath: IndexPath)
    func didTapLogInButton()
}

protocol HomeDataSource: AnyObject {
}

final class HomeController: BaseViewController {
    
    private let eventHandler: HomeEventHandler
    private let dataSource: HomeDataSource
    
    private let searchBarView = MainSearchBarView()
    private var selectedCategories = Set<String>()
    private var categoriesCollectionView = CategoriesCollectionView(categories: ["Adult Birthday", "Kid's birthday", "Wedding", "Friends Gathering", "Love", "Baby Shower", "Seasonal", "Business", "Graduation", "NightLife", "Pet party"])
    
    private var tilesCollectionView: UICollectionView!
    
    private let tiles: [TileModel] = [
        TileModel(imageName: "testImageCover", title: "Eden Turns 30"),
        TileModel(imageName: "testImageCover2", title: "Jennifer & Andrew"),
        TileModel(imageName: "testImageCover3", title: "Little Miss Wonderful"),
        TileModel(imageName: "testImageCover4", title: "Big Day Coming"),
        TileModel(imageName: "testImageCover4", title: "Big Day Coming")
    ]
    
    init(eventHandler: HomeEventHandler, dataSource: HomeDataSource) {
        self.eventHandler = eventHandler
        self.dataSource = dataSource
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 164, height: 234)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        
        tilesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tilesCollectionView.delegate = self
        tilesCollectionView.dataSource = self
        tilesCollectionView.register(TileCollectionViewCell.self, forCellWithReuseIdentifier: TileCollectionViewCell.identifier)
        tilesCollectionView.backgroundColor = .white
        
        searchBarView.delegate = self
        view.backgroundColor = .white
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        view.addSubview(searchBarView)
        view.addSubview(categoriesCollectionView)
        view.addSubview(tilesCollectionView)
    }
    
    override func constrainSubviews() {
        super.constrainSubviews()
        
        searchBarView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 8, left: 16, bottom: .zero, right: 16), excludingEdge: .bottom)
        
        categoriesCollectionView.autoPinEdge(.top, to: .bottom, of: searchBarView, withOffset: 8)
        categoriesCollectionView.autoPinEdge(toSuperviewEdge: .leading)
        categoriesCollectionView.autoPinEdge(toSuperviewEdge: .trailing)
        
        tilesCollectionView.autoPinEdge(.top, to: .bottom, of: categoriesCollectionView, withOffset: 16)
        tilesCollectionView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), excludingEdge: .top)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TileCollectionViewCell.identifier, for: indexPath) as? TileCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: tiles[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate width as half of the collection view width
        let width = (collectionView.bounds.width / 2) - 15  // Adjusting for spacing
        
        // Maintain aspect ratio, for example 4:3 (width:height)
        let aspectRatio: CGFloat = 4.0 / 3.0
        let height = width * aspectRatio
        print(width,height)
        return CGSize(width: width, height: height + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        eventHandler.didSelectItem(at: indexPath)
    }
}

extension HomeController: MainSearchBarViewDelegate {
    func didTapLogInButton() {
        eventHandler.didTapLogInButton()
    }
}
