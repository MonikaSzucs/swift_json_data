//
//  User.swift
//  jsondata
//
//  Created by Developer Resources on 2025-12-31.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let email: String
    let isActive: Bool
    
    init(id:Int, name:String, email:String, isActive:Bool) {
        self.id = id
        self.name = name
        self.email = email
        self.isActive = isActive
    }
}


