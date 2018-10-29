//
//  NetworkError.swift
//  NetworkTool
//
//  Created by SeacenLiu on 2018/6/1.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case `default`
    case jsonDeserialization
    case frequentlyError
    case authorizationError
}
