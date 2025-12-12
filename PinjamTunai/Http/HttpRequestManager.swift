//
//  HttpRequestManager.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/6.
//

import Foundation
import Alamofire

class HttpRequestManager: NSObject {

    static let shared = HttpRequestManager()
    private override init() {}
    
    private var baseURL: String {
        let apiUrl = UserDefaults.standard.string(forKey: "baseUrl")
        return apiUrl?.isEmpty == false ? apiUrl! : "https://cosco-vanijya.com/ommunicationsange"
    }

    func get<T: Decodable>(_ path: String,
                           parameters: [String: Any]? = nil,
                           timeoutInterval: TimeInterval = 10) async throws -> T {
        
        let url = baseURL + path
        let para = ApiPeraConfig.getCommonPara()
        let apiUrl = URLQueryHelper.appendQueries(to: url, parameters: para) ?? ""
        
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        configuration.timeoutIntervalForResource = timeoutInterval
        
        let session = Session(configuration: configuration)
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(apiUrl,
                           method: .get,
                           parameters: parameters,
                           encoding: URLEncoding.default)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let model):
                        continuation.resume(returning: model)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    // MARK: - POST async
    func post<T: Decodable>(_ path: String,
              parameters: [String: Any]? = nil) async throws -> T {

        let url = baseURL + path
        
        let para = ApiPeraConfig.getCommonPara()
        
        let apiUrl = URLQueryHelper.appendQueries(to: url, parameters: para) ?? ""

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(apiUrl,
                       method: .post,
                       parameters: parameters,
                       encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let model):
                        continuation.resume(returning: model)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    // MARK: - Upload async
    func upload<T: Decodable>(_ path: String,
                parameters: [String: Any]?,
                files: [String: Data]? = nil) async throws -> T {

        let url = baseURL + path
        
        let para = ApiPeraConfig.getCommonPara()
        
        let apiUrl = URLQueryHelper.appendQueries(to: url, parameters: para) ?? ""

        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { formData in

                parameters?.forEach { key, value in
                    if let data = "\(value)".data(using: .utf8) {
                        formData.append(data, withName: key)
                    }
                }

                files?.forEach { key, data in
                    formData.append(data,
                                    withName: "hisBringing",
                                    fileName: "\(key).jpg",
                                    mimeType: "image/jpeg")
                }

            }, to: apiUrl)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let model):
                    continuation.resume(returning: model)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

struct URLQueryHelper {
    
    static func buildURL(from baseURL: String,
                        queryParameters: [String: String?]) -> String? {
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        
        var allQueryItems = urlComponents.queryItems ?? []
        
        let newQueryItems = queryParameters.compactMap { key, value -> URLQueryItem? in
            guard let validValue = value, !validValue.isEmpty else {
                return nil
            }
            return URLQueryItem(name: key, value: validValue)
        }
        
        allQueryItems.append(contentsOf: newQueryItems)
        urlComponents.queryItems = allQueryItems.isEmpty ? nil : allQueryItems
        
        return urlComponents.url?.absoluteString
    }
    
    static func appendQueries(to url: String,
                            parameters: [String: String?]) -> String? {
        return buildURL(from: url, queryParameters: parameters)
    }
}
