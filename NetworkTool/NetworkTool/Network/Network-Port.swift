//
//  Network-Port.swift
//  NetworkTool
//
//  Created by SeacenLiu on 2018/6/1.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation

extension Network {
    enum Port: String {
        static let baseUrl = "http://116.196.113.170:9080"
        
        case sendSecurityCode = "/user/sendSecurityCode"
        case login = "/user/login"
        case modify = "/user/modify"
    }
}

extension Network.Port {
    func string() -> String {
        return Network.Port.baseUrl + rawValue
    }
}
