//
//  UserRowView.swift
//  jsondata
//
//  Created by Developer Resources on 2026-01-18.
//

import SwiftUI

struct UserRowView: View {
    let user: User
    let onTap: () -> Void
    let onDelete: () -> Void
    let onEdit: () -> Void
    let onToggleActive: () -> Void
    
    var body: some View {
        HStack {
            // User icon
            ZStack {
                Circle()
                    .fill(user.isActive ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "person.circle.fill")
                    .foregroundColor(user.isActive ? .green : .red)
                    .font(.title2)
            }
            
            // User info
            VStack(alignment: .leading, spacing: 2) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack {
                    Text("ID: \(user.id)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    if user.isActive {
                        Text("Active")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(4)
                    } else {
                        Text("Inactive")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red.opacity(0.2))
                            .foregroundColor(.red)
                            .cornerRadius(4)
                    }
                }
            }
            
            Spacer()
            
            // Edit indicator
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
            
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
        }
        .swipeActions(edge: .leading) {
            Button(action: onToggleActive) {
                Label(user.isActive ? "Deactivate" : "Activate",
                      systemImage: user.isActive ? "person.slash" : "person.fill.checkmark")
            }
            .tint(user.isActive ? .orange : .green)
        }
    }
}
