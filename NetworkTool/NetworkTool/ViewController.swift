//
//  ViewController.swift
//  NetworkTool
//
//  Created by SeacenLiu on 2018/5/31.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    UserModel(user: NetworkTool.User(userId: "13380887881", userNickname: "13380887881", userAvatar: nil), token: "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6IjEzMzgwODg3ODgxIn0.bpGTrpFmGgbtGItAz-N0aFdrKAOi0s7YETVaLwBUWnc")
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        testSendCode()
//        testLogin()
        testModify()
    }

}

private extension ViewController {
    
    func testModify() {
        Network.default.modify(
        type: Network.noneDataType.self,
        nickname: "Seacen",
        avatar: "") { (result) in
            switch result {
            case .success(_):
                print("成功修改")
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
}

