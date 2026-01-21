//
//  UsersListView.swift
//  jsondata
//

import SwiftUI

struct UsersListView: View {
    @State private var users: [User] = []
    @State private var showingAddUser = false
    @State private var showingEditUser = false
    @State private var userToEdit: User?
    @State private var newUserName = ""
    @State private var newUserEmail = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            contentView
        }
        .sheet(isPresented: $showingAddUser) {
            addUserSheet
        }
        .sheet(isPresented: $showingEditUser) {
            editUserSheet
        }
        .alert("Status", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Main Content
    private var contentView: some View {
        VStack {
            statusHeader
            
            List {
                usersSection
                actionsSection
            }
        }
        .navigationTitle("User Manager")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddUser = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Reload") {
                    loadUsers()
                }
            }
        }
        .onAppear {
            loadUsers()
        }
    }
    
    // MARK: - Header
    private var statusHeader: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text("Writing to: users.json")
                .font(.caption)
            Spacer()
            Text("\(users.count) users")
                .font(.caption)
                .bold()
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    // MARK: - Users Section
    private var usersSection: some View {
        Section(header: Text("Current Users")) {
            if users.isEmpty {
                emptyStateView
            } else {
                ForEach(users) { user in
                    UserRowView(
                        user: user,
                        onTap: { editUser(user) },
                        onDelete: { deleteUser(user) },
                        onEdit: { editUser(user) },
                        onToggleActive: { toggleUserActive(user) }
                    )
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        Text("No users yet")
            .foregroundColor(.gray)
            .italic()
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: - Actions Section
    private var actionsSection: some View {
        Section(header: Text("File Actions")) {
            Button("📁 Show File Info") {
                showAlert(DataService.shared.getFileInfo())
            }
            
            Button("🔄 Reload from JSON") {
                loadUsers()
                showAlert("Reloaded from users.json")
            }
            
            Button("➕ Add New User") {
                showingAddUser = true
            }
        }
    }
    
    // MARK: - Add User Sheet
    private var addUserSheet: some View {
        NavigationView {
            Form {
                Section(header: Text("Add New User")) {
                    TextField("Name", text: $newUserName)
                    TextField("Email", text: $newUserEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section {
                    Button("Save to users.json") {
                        addNewUser()
                    }
                    .disabled(newUserName.isEmpty || newUserEmail.isEmpty)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Add User")
            .navigationBarItems(
                trailing: Button("Cancel") {
                    showingAddUser = false
                    newUserName = ""
                    newUserEmail = ""
                }
            )
        }
    }
    
    // MARK: - Edit User Sheet
    private var editUserSheet: some View {
        NavigationView {
            if let user = userToEdit {
                EditUserView(user: user) { updatedUser in
                    updateUser(updatedUser)
                }
            } else {
                errorView
            }
        }
    }
    
    private var errorView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("No User Selected")
                .font(.title2)
                .bold()
            
            Text("Please select a user to edit.")
                .foregroundColor(.secondary)
            
            Button("Close") {
                showingEditUser = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("Error")
        .navigationBarItems(
            trailing: Button("Close") {
                showingEditUser = false
            }
        )
    }
    
    // MARK: - Data Functions
    private func loadUsers() {
        users = DataService.shared.loadUsersFromProject()
    }
    
    private func deleteUser(_ user: User) {
        if DataService.shared.deleteUser(withId: user.id) {
            users.removeAll { $0.id == user.id }
            showAlert("Deleted \(user.name)")
        } else {
            showAlert("Failed to delete \(user.name)")
        }
    }
    
    private func toggleUserActive(_ user: User) {
        let updatedUser = User(
            id: user.id,
            name: user.name,
            email: user.email,
            isActive: !user.isActive
        )
        
        if DataService.shared.updateUser(updatedUser) {
            if let index = users.firstIndex(where: { $0.id == user.id }) {
                users[index] = updatedUser
                showAlert("\(user.name) is now \(updatedUser.isActive ? "active" : "inactive")")
            }
        } else {
            showAlert("Failed to update \(user.name)")
        }
    }
    
    private func editUser(_ user: User) {
        userToEdit = user
        showingEditUser = true
    }
    
    private func updateUser(_ updatedUser: User) {
        if DataService.shared.updateUser(updatedUser) {
            if let index = users.firstIndex(where: { $0.id == updatedUser.id }) {
                users[index] = updatedUser
                showAlert("Updated \(updatedUser.name)")
            }
            userToEdit = nil
        } else {
            showAlert("Failed to update user")
        }
    }
    
    private func addNewUser() {
        let newId = (users.map { $0.id }.max() ?? 0) + 1
        let newUser = User(
            id: newId,
            name: newUserName.trimmingCharacters(in: .whitespaces),
            email: newUserEmail.trimmingCharacters(in: .whitespaces),
            isActive: true
        )
        
        if DataService.shared.addUser(newUser) {
            users.append(newUser)
            newUserName = ""
            newUserEmail = ""
            showingAddUser = false
            showAlert("Added \(newUser.name)")
        } else {
            showAlert("Failed to add user")
        }
    }
    
    private func showAlert(_ message: String) {
        alertMessage = message
        showingAlert = true
    }
}
