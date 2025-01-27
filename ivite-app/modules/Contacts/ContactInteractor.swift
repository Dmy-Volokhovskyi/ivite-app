import Foundation

protocol ContactInteractorDelegate: AnyObject {
    func contactDownloadSuccess()
}

final class ContactInteractor: BaseInteractor {
    var currentUser: IVUser?
    
    override init(serviceProvider: ServiceProvider) {
        super.init(serviceProvider: serviceProvider)
        
        currentUser = serviceProvider.userDefaultsService.getUser()
    }
    
    var contactCards = [ContactCardModel]()
    var groups: [ContactGroup] = []
    
    weak var delegate: ContactInteractorDelegate?
    
    func checkForUserUpdates() {
        currentUser = serviceProvider.userDefaultsService.getUser()
    }
    
    /// Fetch all contacts and groups for the current user from Firestore
    func fetchAllContactsAndGroups() async {
        guard let currentUser = currentUser else { return }
        
        do {
            // Fetch contacts
            let contacts = try await serviceProvider.firestoreManager.fetchAllContacts(userId: currentUser.userId)
            self.contactCards = contacts
            
            // Fetch groups
            let groups = try await serviceProvider.firestoreManager.fetchAllGroups(for: currentUser.userId)
            self.groups = groups
            
            // Notify the presenter that the data is ready
            await MainActor.run {
                delegate?.contactDownloadSuccess()
            }
        } catch {
            // Handle errors if needed
            print("Error fetching contacts or groups: \(error)")
        }
    }
    
    /// Delete a contact by ID
    func deleteContact(_ contact: ContactCardModel) async {
        guard let currentUser = currentUser else { return }
        do {
            try await serviceProvider.firestoreManager.deleteContact(userId: currentUser.userId, contactId: contact.id)
            contactCards.removeAll(where: { $0.id == contact.id })
            await MainActor.run {
                delegate?.contactDownloadSuccess()
            }
        } catch {
            print("Error deleting contact: \(error)")
        }
    }
    
    /// Add or update a contact
    func saveContact(_ contact: ContactCardModel) async {
        guard let currentUser = currentUser else { return }
        do {
            try await serviceProvider.firestoreManager.createOrUpdateContact(userId: currentUser.userId, contact: contact)
            if let index = contactCards.firstIndex(where: { $0.id == contact.id }) {
                contactCards[index] = contact
            } else {
                contactCards.append(contact)
            }
            await MainActor.run {
                delegate?.contactDownloadSuccess()
            }
        } catch {
            print("Error saving contact: \(error)")
        }
    }
    
    /// Save or update a group
    func saveGroup(_ group: ContactGroup) async {
        guard let currentUser = currentUser else { return }
        
        do {
            // Save or update the group in Firestore
            try await serviceProvider.firestoreManager.createGroup(for: currentUser.userId, group: group)
            
            // Update the group locally
            if let index = groups.firstIndex(where: { $0.id == group.id }) {
                groups[index] = group // Update existing group
            } else {
                groups.append(group) // Append new group
            }
            
            // Notify the presenter that the data has changed
            await MainActor.run {
                delegate?.contactDownloadSuccess()
            }
        } catch {
            print("Error saving group: \(error)")
        }
    }
    
    func removeGroup(_ group: ContactGroup) async {
        guard let currentUser = currentUser else { return }
        
        do {
            // 1. Remove the group from Firestore
            try await serviceProvider.firestoreManager.deleteGroup(for: currentUser.userId, groupId: group.id)
            
            // 2. Update all contacts to remove the group ID
            for contact in contactCards {
                if contact.groupIds.contains(group.id) {
                    // Remove group ID from contact's groupIds
                    contact.groupIds.removeAll { $0 == group.id }
                    
                    // Update the contact in Firestore
                    try await serviceProvider.firestoreManager.createOrUpdateContact(userId: currentUser.userId, contact: contact)
                }
            }
            
            // 3. Remove the group locally
            groups.removeAll { $0.id == group.id }
            
            // 4. Notify the presenter to update the UI
            await MainActor.run {
                delegate?.contactDownloadSuccess()
            }
            
        } catch {
            print("Error removing group: \(error)")
        }
    }
}
