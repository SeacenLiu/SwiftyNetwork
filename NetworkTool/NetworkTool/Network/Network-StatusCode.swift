//
//  Network-StatusCode.swift
//  NetworkTool
//
//  Created by SeacenLiu on 2018/6/1.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation

extension Network {
    enum Statuscode: Int, Decodable {
        case success = 200
        case authenticationError = 401
        case failed = 500
    }
}
