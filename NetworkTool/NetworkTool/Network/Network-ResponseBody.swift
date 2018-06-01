//
//  Network-ResponseBody.swift
//  NetworkTool
//
//  Created by SeacenLiu on 2018/6/1.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation

extension Network {
    struct ResponseBody<T: Decodable>: Decodable {
        let code: Statuscode
        let data: T
        let info: String
    }
    
    struct ResponseBodyWithoutData: Decodable {
        let code: Statuscode
        let info: String
    }
}
