//
//  Network-external.swift
//  NetworkTool
//
//  Created by SeacenLiu on 2018/10/29.
//  Copyright © 2018 成. All rights reserved.
//

import Foundation

extension Network {
    // TODO: - 按实际需求修改Token获取方式
    var token: String? {
        return nil
    }
}

// MARK: - 测试用接口
extension Network {
    func testGet(completion: @escaping requestCompletion<TestModel>) {
        request(url: .testGet, method: .get, completion: completion)
    }
}
