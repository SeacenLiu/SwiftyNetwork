//
//  NetworkError.swift
//  NetworkTool
//
//  Created by SeacenLiu on 2018/6/1.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation

extension Network {
    enum Result<T> {
        case success(T)
        case failure(NetworkError)
    }
}

enum NetworkError: Error {
    case `default`
    case jsonDeserialization
    case frequentlyError
    case authorizationError
}
