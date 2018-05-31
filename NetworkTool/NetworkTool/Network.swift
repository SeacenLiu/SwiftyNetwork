//
//  Network.swift
//  NetworkTool
//
//  Created by SeacenLiu on 2018/5/31.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation
import Alamofire 
import SwiftyJSON

class Network {
    static let `default` = Network()
    
    let baseUrl = "http://116.196.113.170:9080"
    
    static let ok = 200
    static let codeKey = "code"
    static let infoKey = "info"
    static let dataKey = "data"
    
    typealias RequestSuccess = (_ result: Any)->()
    typealias RequestFailure = (_ error: NSError)->()
    
    enum Result<Value: Codable> {
        case success(Value)
        case failure(NSError)
    }
    
    struct ResponseBody<Value: Decodable> {
        let code: Int
        let data: Value?
        let info: String
    }

    private init() {}
}

// MARK: - 用户管理接口
extension Network {
    public func sendSecurityCode<T: Decodable>(
        type: T.Type,
        phone: String,
        success: @escaping RequestSuccess,
        failure: @escaping RequestFailure) {
        let urlString = "user/sendSecurityCode"
        request(type: type,
                url: urlString,
                method: .get,
                parameters: ["phoneNum": phone],
                success: success,
                failure: failure)
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
        type: T.Type,
        url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        success: @escaping RequestSuccess,
        failure: @escaping RequestFailure) {
        Alamofire.request(
            url,
            method: method,
            parameters: commonParameters(parameters: parameters),
            encoding: encoding,
            headers: headers).responseData { (response) in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    if let code = json[Network.codeKey].int,
                        code == Network.ok {
                        if let modelStr = json[Network.dataKey].string,
                            let modelData = modelStr.data(using: .utf8),
                            let model = try? JSONDecoder().decode(type, from: modelData) {
                            success(model)
                        } else {
                            let err = NSError.network(
                                reason: ErrorMessage.json.rawValue,
                                code: ErrorCode.json.rawValue)
                            failure(err)
                        }
                    } else {
                        var reason = ErrorMessage.default.rawValue
                        var code = ErrorCode.default.rawValue
                        if let info = json[Network.infoKey].string {
                            reason = info
                        }
                        if let status = json[Network.codeKey].int {
                            code = status
                        }
                        let err = NSError.network(
                            reason: reason,
                            code: code)
                        failure(err)
                    }
                    break
                case .failure(let error):
                    failure(error as NSError)
                    break
                }
        }
    }
}

enum ErrorCode: Int {
    case `default` = -1212
    case json = -1213
    case parameter = -1214
}

enum ErrorMessage: String {
    case `default` = "网络状态不佳，请稍候再试!"
    case json = "服务器数据解析错误!"
    case parameter = "参数错误，请稍候再试!"
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

protocol StringProtocol {}
extension String : StringProtocol {}












