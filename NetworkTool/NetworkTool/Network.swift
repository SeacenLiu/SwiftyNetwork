//
//  Network.swift
//  NetworkTool
//
//  Created by SeacenLiu on 2018/5/31.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation
import Alamofire

class Network {
    static let `default` = Network()
    
    enum Port: String {
        static let baseUrl = "http://116.196.113.170:9080/"
        
        case sendSecurityCode = "user/sendSecurityCode"
        case login = "user/login"
    }
    
    var token: String? {
        // TODO: - 需要按实际修改Token获取方式
        return UserAccount.shared.token
    }
    
    static let ok = 200
    
    private init() {}
}

extension Network {
    
    typealias requestCompletion<T: Decodable> = (Result<T>)->()
    
    enum Result<T: Decodable> {
        case success(T?)
        case failure(NSError)
    }
    
    struct ResponseBody<T: Decodable>: Decodable {
        let code: Int
        let data: T?
        let info: String
    }
}

// MARK: - 用户账号管理接口
extension Network {
    public func testSendCode<T: Decodable>(
        phone: String,
        completion: @escaping requestCompletion<T>) {
        
        request(
            url: Port.sendSecurityCode,
            method: .get,
            parameters: ["phoneNum": phone],
            completion: completion)
    }
    
    public func testLogin<T: Decodable>(
        phone: String,
        code: String,
        completion: @escaping requestCompletion<T>) {
        
        request(
            url: Port.login,
            method: .post,
            parameters: [
            "phoneNum": phone,
            "code": code
            ],
            completion: completion)
    }
}

private extension Network {
    /// 添加通用参数
    func commonParameters(parameters: Parameters?) -> Parameters {
        var newParameters: [String: Any] = [:]
        if parameters != nil {
            newParameters = parameters!
        }
        if let tk = token {
            newParameters["token"] = tk
        }
        return newParameters
    }
    
    /// 统一的API请求入口
    func request<T: Decodable>(
        url: Port,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        completion: @escaping requestCompletion<T>) {
        let urlStr = url.string()
        Alamofire.request(
            urlStr,
            method: method,
            parameters: parameters).responseData { (response) in
            switch response.result {
            case .success(let data):
                if let body = try? JSONDecoder().decode(ResponseBody<T>.self, from: data) {
                    if body.code == Network.ok {
                        completion(Result<T>.success(body.data))
                    } else {
                        let info = body.info
                        let code = body.code
                        let err = NSError.network(
                            reason: info,
                            code: code)
                        completion(Result<T>.failure(err))
                    }
                } else {
                    let err = NSError.network(
                        reason: ErrorMessage.json.rawValue,
                        code: ErrorCode.json.rawValue)
                    completion(Result<T>.failure(err))
                }
            case .failure(let err):
                completion(Result<T>.failure(err as NSError))
            }
        }
    }
    
}

extension Network.Port {
    func string() -> String {
        return Network.Port.baseUrl + rawValue
    }
}

enum ErrorCode: Int {
    case `default` = -1212
    case json = -1213
}

enum ErrorMessage: String {
    case `default` = "网络状态不佳，请稍候再试!"
    case json = "服务器数据解析错误!"
}

extension NSError {
    class func network(reason: String, code: Int) -> NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: reason,
            NSLocalizedFailureReasonErrorKey: reason
        ]
        return NSError(
            domain: "com.seacen.networkerror",
            code: code,
            userInfo: userInfo)
    }
}







