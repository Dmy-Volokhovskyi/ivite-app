import Foundation
protocol PreviewInviteInteractorDelegate: AnyObject {
}

final class PreviewInviteInteractor: BaseInteractor {
    weak var delegate: PreviewInviteInteractorDelegate?
    
    let user: IVUser?
    let previewMode: Bool
    var creatorFlowModel: CreatorFlowModel
    
    init(previewMode: Bool, creatorFlowModel: CreatorFlowModel, serviceProvider: ServiceProvider) {
        self.creatorFlowModel = creatorFlowModel
#warning("Come back to this later")
        
        
        self.user =  IVUser(
            userId: "authUser.uid",
            firstName: "Unknown",
            email: "No Email",
            profileImageURL: "",
            createdAt: Date(),
            remainingInvites: 10,
            isPremium: false
        )
        self.previewMode = previewMode
        
        super.init(serviceProvider: serviceProvider)
    }
}
