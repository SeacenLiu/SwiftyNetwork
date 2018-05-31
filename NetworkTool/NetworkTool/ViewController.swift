//
//  ViewController.swift
//  NetworkTool
//
//  Created by SeacenLiu on 2018/5/31.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLogin()
    }

}

private extension ViewController {
    
    func testLogin() {
        Network.default.testLogin(phone: "13380887881", code: "4675") { (result: Network.Result<UserModel>) in
            switch result {
            case .success(let value):
                print(value)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func testSendCode() {
        Network.default.testSendCode(phone: "13380887881") { (result: Network.Result<String>) in
            switch result {
            case .success(let value):
                print(value)
            case .failure(let err):
                print(err)
            }
        }
    }
}

