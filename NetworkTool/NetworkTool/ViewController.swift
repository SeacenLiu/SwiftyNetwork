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
        Network.default.login(type: UserModel.self, phone: "13380887881", code: "9933", success: { (model) in
            if let m = model as? UserModel {
                print(m)
            }
        }) { (error) in
            print(error)
        }
    }
    
    /// 先不要用这个!!!
    func testSendCode() {
        Network.default.sendSecurityCode(type: String.self, phone: "13380887881", success: { (model) in
            if let m = model as? String {
                print(m)
            }
        }) { (error) in
            print(error)
        }
    }
}

