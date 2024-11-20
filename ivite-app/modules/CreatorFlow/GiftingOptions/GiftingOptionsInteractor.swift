protocol GiftingOptionsDelegate: AnyObject {
    func didEndGiftingOptions(gifts: [Gift])
}

protocol GiftingOptionsInteractorDelegate: AnyObject {
}

final class GiftingOptionsInteractor: BaseInteractor {
    weak var delegate: GiftingOptionsInteractorDelegate?
    weak var giftingOptionsDelegate: GiftingOptionsDelegate?
    
    var gifts: [Gift]
    
    init(gifts: [Gift],
         giftingOptionsDelegate: GiftingOptionsDelegate,
         serviceProvider: ServiceProvider) {
        self.giftingOptionsDelegate = giftingOptionsDelegate
        self.gifts = gifts
        super.init(serviceProvider: serviceProvider)
        
        self.giftingOptionsDelegate = giftingOptionsDelegate
    }
}
