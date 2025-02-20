protocol GiftingOptionsDelegate: AnyObject {
    func didEndGiftingOptions(gifts: [Gift], wasEditing: Bool)
}

protocol GiftingOptionsInteractorDelegate: AnyObject {
}

final class GiftingOptionsInteractor: BaseInteractor {
    weak var delegate: GiftingOptionsInteractorDelegate?
    weak var giftingOptionsDelegate: GiftingOptionsDelegate?
    
    var gifts: [Gift]
    
    let isEditing: Bool
    
    init(gifts: [Gift],
         giftingOptionsDelegate: GiftingOptionsDelegate,
         isEditing: Bool,
         serviceProvider: ServiceProvider) {
        self.giftingOptionsDelegate = giftingOptionsDelegate
        self.gifts = gifts
        self.isEditing = isEditing
        super.init(serviceProvider: serviceProvider)
        
        self.giftingOptionsDelegate = giftingOptionsDelegate
    }
}
