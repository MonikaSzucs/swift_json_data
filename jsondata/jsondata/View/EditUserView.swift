//
//  EditUserView.swift
//  jsondata
//

import SwiftUI

struct EditUserView: View {
    @Environment(\.dismiss) private var dismiss
    let user: User
    let onSave: (User) -> Void
    
    @State private var name: String
    @State private var email: String
    @State private var isActive: Bool
    
    init(user: User, onSave: @escaping (User) -> Void) {
        self.user = user
        self.onSave = onSave
        _name = State(initialValue: user.name)
        _email = State(initialValue: user.email)
        _isActive = State(initialValue: user.isActive)
        
        print("EditUserView initialized for: \(user.name)")
    }
    
    var body: some View {
        Form {
            Section(header: Text("User Information")) {
                TextField("Name", text: $name)
                    .onAppear {
                        print("Name field: \(name)")
                    }
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onAppear {
                        print("Email field: \(email)")
                    }
            }
            
            Section(header: Text("Status")) {
                Toggle("Active User", isOn: $isActive)
            }
            
            Section(header: Text("User ID")) {
                Text("ID: \(user.id)")
                    .foregroundColor(.gray)
            }
            
            Section {
                Button("Save Changes") {
                    saveChanges()
                }
                .disabled(name.isEmpty || email.isEmpty)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .listRowBackground(
                    name.isEmpty || email.isEmpty ?
                    Color.gray : Color.blue
                )
            }
        }
        .navigationTitle("Edit \(user.name)")
        .navigationBarItems(
            leading: Button("Cancel") {
                print("Edit cancelled")
                dismiss()
            },
            trailing: Button("Save") {
                saveChanges()
            }
            .disabled(name.isEmpty || email.isEmpty)
        )
        .onAppear {
            print("EditUserView appeared for user: \(user.name)")
        }
    }
    
    private func saveChanges() {
        print("Saving changes for user ID: \(user.id)")
        print("New name: \(name), New email: \(email), New active: \(isActive)")
        
        let updatedUser = User(
            id: user.id,
            name: name.trimmingCharacters(in: .whitespaces),
            email: email.trimmingCharacters(in: .whitespaces),
            isActive: isActive
        )
        
        onSave(updatedUser)
        dismiss()
    }
}
