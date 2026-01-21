//
//  DataService.swift
//  jsondata
//

import Foundation

class DataService {
    static let shared = DataService()
    private let fileName = "users.json"
    
    // MARK: - Your exact project path (UPDATE THIS PATH!)
    private let projectJSONPath = "/Users/developerresources/Desktop/jsondata/jsondata/Data/users.json"
    
    // MARK: - Debug logging
    private func log(_ message: String) {
        print("📦 DataService: \(message)")
    }
    
    // MARK: - Load Users
    func loadUsersFromProject() -> [User] {
        log("Loading from: \(projectJSONPath)")
        
        let fileManager = FileManager.default
        
        // Check if file exists
        if !fileManager.fileExists(atPath: projectJSONPath) {
            log("❌ File not found, creating default")
            return createDefaultFile()
        }
        
        do {
            // Read file
            let url = URL(fileURLWithPath: projectJSONPath)
            let data = try Data(contentsOf: url)
            
            // Decode JSON
            let decoder = JSONDecoder()
            let users = try decoder.decode([User].self, from: data)
            
            log("✅ Loaded \(users.count) users")
            return users
            
        } catch {
            log("❌ Error loading: \(error)")
            return createDefaultFile()
        }
    }
    
    // MARK: - Save Users (THIS IS CRITICAL!)
    func saveUsersToProject(_ users: [User]) -> Bool {
        log("💾 Saving \(users.count) users...")
        
        do {
            // Create encoder with pretty printing
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            // Encode to JSON
            let data = try encoder.encode(users)
            
            // Write to file
            let url = URL(fileURLWithPath: projectJSONPath)
            try data.write(to: url)
            
            log("✅ Successfully saved to: \(projectJSONPath)")
            
            // Verify by reading back
            let verifyData = try Data(contentsOf: url)
            let verifyUsers = try JSONDecoder().decode([User].self, from: verifyData)
            log("✅ Verified: File now has \(verifyUsers.count) users")
            
            return true
            
        } catch {
            log("❌ Error saving: \(error)")
            return false
        }
    }
    
    // MARK: - Create Default File
    private func createDefaultFile() -> [User] {
        log("Creating default users...")
        
        let defaultUsers = [
            User(id: 1, name: "John Doe", email: "john@example.com", isActive: true),
            User(id: 2, name: "Jane Smith", email: "jane@example.com", isActive: false),
            User(id: 3, name: "Bob Johnson", email: "bob@example.com", isActive: true)
        ]
        
        // Save the defaults
        if saveUsersToProject(defaultUsers) {
            log("✅ Default file created")
        } else {
            log("❌ Failed to create default file")
        }
        
        return defaultUsers
    }
    
    // MARK: - CRUD Operations (MUST call saveUsersToProject!)
    func addUser(_ user: User) -> Bool {
        log("➕ Adding user: \(user.name)")
        
        // 1. Load current users
        var users = loadUsersFromProject()
        
        // 2. Add new user
        users.append(user)
        
        // 3. Save back to file
        return saveUsersToProject(users)
    }
    
    func deleteUser(withId id: Int) -> Bool {
        log("🗑️ Deleting user ID: \(id)")
        
        // 1. Load current users
        var users = loadUsersFromProject()
        
        // 2. Remove user
        let beforeCount = users.count
        users.removeAll { $0.id == id }
        
        // 3. Check if anything was removed
        if users.count < beforeCount {
            // 4. Save back to file
            return saveUsersToProject(users)
        }
        
        return false
    }
    
    func updateUser(_ user: User) -> Bool {
        log("✏️ Updating user: \(user.name)")
        
        // 1. Load current users
        var users = loadUsersFromProject()
        
        // 2. Find and update user
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
            
            // 3. Save back to file
            return saveUsersToProject(users)
        }
        
        log("❌ User with ID \(user.id) not found")
        return false
    }
    
    // MARK: - File Info
    func getFileInfo() -> String {
        let users = loadUsersFromProject()
        
        var info = "=== FILE STATUS ===\n"
        info += "Path: \(projectJSONPath)\n"
        info += "Users: \(users.count)\n\n"
        
        info += "USER LIST:\n"
        for user in users {
            info += "• \(user.name) (ID: \(user.id))\n"
            info += "  Email: \(user.email)\n"
            info += "  Status: \(user.isActive ? "✅ Active" : "❌ Inactive")\n\n"
        }
        
        return info
    }
}
