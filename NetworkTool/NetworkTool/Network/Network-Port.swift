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
        static let baseUrl = "http://www.mocky.io"

        case testGet = "/v2/5bd6ab833500004900fd7c63"
    }
}

extension Network.Port {
    func string() -> String {
        return Network.Port.baseUrl + rawValue
    }
}
