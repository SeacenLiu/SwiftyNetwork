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
        
        Network.default.testGet { (result) in
            switch result {
            case .success(let m):
                print(m)
            case .failure(let err):
                print(err)
            }
        }
    }

}
