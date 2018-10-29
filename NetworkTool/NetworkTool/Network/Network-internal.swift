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
    
    private init() {}
    
    typealias requestCompletion<T> = (Result<T>)->()
    
    enum Result<T> {
        case success(T)
        case failure(NetworkError)
    }
    
}

extension Network {
    /// 通用请求头
    private func commonHeaders(headers: HTTPHeaders?) -> HTTPHeaders {
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlStr = url.string()
        Alamofire.request(
            urlStr,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: commonHeaders(headers: headers)).responseData { (response) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch response.result {
                case .success(let data):
                    self.successHandle(data: data, completion: completion)
                case .failure(_):
                    self.failureHandle(completion: completion)
                }
        }
    }
    
    /// 网络请求成功处理
    private func successHandle<T: Decodable>(data: Data, completion: requestCompletion<T>) {
        do {
            guard let body = try? JSONDecoder().decode(ResponseBody<T>.self, from: data) else {
                throw NetworkError.jsonDeserialization
            }
            switch body.code {
            case .success:
                completion(Result<T>.success(body.data))
            case .frequently:
                throw NetworkError.frequentlyError
            default:
                throw NetworkError.default
            }
        } catch(let error) {
            if let err = error as? NetworkError {
                completion(Result<T>.failure(err))
            }
        }
    }
    
    /// 网络请求失败处理
    private func failureHandle<T>(completion: requestCompletion<T>) {
        completion(Result<T>.failure(NetworkError.default))
    }
}




