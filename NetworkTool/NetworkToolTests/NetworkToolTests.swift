//
//  NetworkToolTests.swift
//  NetworkToolTests
//
//  Created by SeacenLiu on 2018/6/1.
//  Copyright © 2018年 成. All rights reserved.
//

import XCTest
@testable import NetworkTool

class NetworkToolTests: XCTestCase {
    
    func testSendCode() {
        Network.default.sendCode(
            type: String.self,
            phone: "13380887881") {
                (result) in
                switch result {
                case .success(let value):
                    print(value)
                case .failure(let err):
                    print(err)
                }
        }
    }
    
    func testLogin() {
        Network.default.login(
            type: UserModel.self,
            phone: "13380887881",
            code: "6121") {
                (result) in
                switch result {
                case .success(let value):
                    print(value)
                    break
                case .failure(let err):
                    print(err)
                }
        }
    }
    
}
