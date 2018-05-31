//
//  UserAccount.swift
//  NetworkTool
//
//  Created by SeacenLiu on 2018/5/31.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation

class UserAccount {
    static let shared = UserAccount()
    
    var user: UserModel?
    
    var token: String? {
        return user?.token
    }
    
    private init() {}
}

struct UserModel: Codable {
    let user: User
    let token: String
}

struct User: Codable {
    let userId: String
    let userNickname: String
    let userAvatar: String?
}
