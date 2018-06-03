//
//  Network.swift
//  NetworkTool
//
//  Created by SeacenLiu on 2018/5/31.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation
import Alamofire

/**
 * Network
 * Network-Public
 * Network-Port
 * Network-StatusCode
 * Network-ResponseBody
 * NetworkError
 */

/// ToDoList : 处理这个情况的方法
/** 后台的Data为空情况JSON
 {
 "code": 400,
 "info": "验证失败",
 "data": null
 }
 */

class Network {
    static let `default` = Network()
    
    var token: String? {
        // TODO: - 需要按实际修改Token获取方式
        return "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6IjEzMzgwODg3ODgxIn0.bpGTrpFmGgbtGItAz-N0aFdrKAOi0s7YETVaLwBUWnc" //UserAccount.shared.token
    }
    
    private init() {}
    
    typealias requestCompletion<T> = (Result<T>)->()
    
}

// MARK: - 用户账号管理接口
extension Network {
    public func sendCode<T: Decodable>(
        type: T.Type,
        phone: String,
        completion: @escaping requestCompletion<T>) {
        request(
            url: .sendSecurityCode,
            method: .get,
            parameters: ["phoneNum": phone],
            completion: completion)
    }
    
    public func login<T: Decodable>(
        type: T.Type,
        phone: String,
        code: String,
        completion: @escaping requestCompletion<T>) {
        request(
            url: .login,
            method: .post,
            parameters: [
            "phoneNum": phone,
            "code": code
            ],
            completion: completion)
    }
    
    public func modify<T: Decodable>(
        type: T.Type,
        nickname: String,
        avatar: String,
        completion: @escaping requestCompletion<T>) {
        request(
            url: .modify,
            method: .put,
            parameters: [
                "nickname": nickname,
                "avatar": avatar
            ],
            completion: completion)
    }
}

// MARK: - 留言相关接口
extension Network {
    public func loadMessage<T: Decodable>(
        type: T.Type,
        completion: @escaping requestCompletion<T>) {
        request(url: .message, method: .get, completion: completion)
    }
    
    public func saveMessage<T: Decodable>(
        type: T.Type,
        messageContent: String,
        modelId: Int,
        messageLongitude: Double,
        messageLatitude: Double,
        messageTime: TimeInterval,
        completion: @escaping requestCompletion<T>) {
        let parameters = [
            "messageContent": messageContent,
            "modelId": modelId,
            "messageLongitude": messageLongitude,
            "messageLatitude": messageLatitude,
            "messageTime": messageTime
            ] as Parameters
        request(
            url: .message,
            method: .post,
            parameters: parameters,
            completion: completion)
    }
    
    public func getMessage<T: Decodable>(
        type: T.Type,
        messageId: String,
        completion: @escaping requestCompletion<T>) {
        let parameters = ["messageId": messageId]
        request(
            url: .message,
            method: .get,
            parameters: parameters,
            completion: completion)
    }
}

private extension Network {
    func commonHeaders(headers: HTTPHeaders?) -> HTTPHeaders {
        var newHeaders: HTTPHeaders = [:]
        if headers != nil {
            newHeaders = headers!
        }
        if let tk = token {
            newHeaders["Authorization"] = tk
        }
        return newHeaders
    }
    
    /// Data有返回数据的API请求入口
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
            parameters: parameters,
            encoding: encoding,
            headers: commonHeaders(headers: headers)).responseData { (response) in
                do {
                    switch response.result {
                    case .success(let data):
                        guard let body = try? JSONDecoder().decode(ResponseBody<T>.self, from: data) else {
                            throw NetworkError.jsonDeserialization
                        }
                        switch body.code {
                        case .success:
                            completion(Result<T>.success(body.data))
                        default:
                            throw NetworkError.default
                        }
                    case .failure(_):
                        print("网络请求失败的")
                        throw NetworkError.default
                    }
                } catch(let err) {
                    completion(Result<T>.failure(err))
                }
        }
    }
}




