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
    
    let baseUrl = "http://116.196.113.170:9080"
    
    /// 返回完整路径字符串
    func completionString(path: String) -> String {
        if path.hasPrefix("/") {
            return baseUrl + path
        }
        return baseUrl + "/" + path
    }
    
    static let ok = 200
    
    enum Result<T> where T: Decodable  {
        case success(T)
        case failure(NSError)
    }
    
    struct ResponseBody<T: Decodable>: Decodable {
        let code: Int
        let data: T?
        let info: String
    }

    private init() {}
}

// MARK: - 用户管理接口
extension Network {
    public func testSendCode<T: Decodable>(
        phone: String,
        completion: @escaping (Result<T>)->()) {
        
        let urlString = "/user/sendSecurityCode"
        request(
            url: urlString,
            method: .get,
            parameters: ["phoneNum": phone],
            completion: completion)
    }
    
    public func testLogin<T: Decodable>(
        phone: String,
        code: String,
        completion: @escaping (Result<T>)->()) {
        
        let urlString = "user/login"
        request(
            url: urlString,
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
        
        /// 添加通用参数
        /// 用户token参数
        if let token = UserAccount.shared.token {
            newParameters["token"] = token
        }
        return newParameters
    }
    
    /// 统一的API请求入口
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T>)->()) {
        let urlStr = completionString(path: url)
        print(urlStr)
        Alamofire.request(
            urlStr,
            method: .get,
            parameters: parameters).responseData { (response) in
            switch response.result {
            case .success(let data):
                if let body = try? JSONDecoder().decode(ResponseBody<T>.self, from: data) {
                    if body.code == Network.ok {
                        if let model = body.data {
                            completion(Result<T>.success(model))
                        } else {
                            // ok + data空 的处理
                            let err = NSError.network(
                                reason: ErrorMessage.none.rawValue,
                                code: ErrorCode.none.rawValue)
                            completion(Result<T>.failure(err))
                        }
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

enum ErrorCode: Int {
    case `default` = -1212
    case json = -1213
    case none = -1214
}

enum ErrorMessage: String {
    case `default` = "网络状态不佳，请稍候再试!"
    case json = "服务器数据解析错误!"
    case none = "服务器没有返回数据"
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







