import UIKit

final class EventsRouter: BaseRouter {
    
    func switchToTab(index: Int) {
        guard let tabBarController = controller?.tabBarController else {
            print("Tab bar controller not found")
            return
        }
        tabBarController.selectedIndex = index
    }
    
    func showPreview(creatorFlowModel: CreatorFlowModel, serviceProvider: ServiceProvider) {
        let previewController = PreviewInviteBuilder(serviceProvider: serviceProvider)
            .make(previewMode: false, creatorFlowModel: creatorFlowModel)
        
        let navController = UINavigationController(rootViewController: previewController)
        navController.modalPresentationStyle = .popover

        self.controller?.present(navController, animated: true, completion: nil)
    }

}
