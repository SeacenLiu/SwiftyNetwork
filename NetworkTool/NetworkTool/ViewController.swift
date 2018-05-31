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
        testLogin()
    }

}

private extension ViewController {
    func testLogin() {
        Network.default.testLogin(phone: "13380887881", code: "6121") { (result: Network.Result<UserModel>) in
            switch result {
            case .success(let value):
                print(value ?? "空的但成功了")
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func testSendCode() {
        Network.default.testSendCode(phone: "18933399561") { (result: Network.Result<String>) in
            switch result {
            case .success(let value):
                print(value ?? "空的但成功了")
            case .failure(let err):
                print(err)
            }
        }
    }
}

