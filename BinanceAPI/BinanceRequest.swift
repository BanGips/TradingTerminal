//
//  BinanceRequest.swift
//  BinanceApi
//
//  Created by Sergei Kastyukovets on 28.01.23.
//

import Foundation
import Alamofire

public protocol BinanceRequest: URLRequestConvertible {
    associatedtype Response: Decodable
    var endPoint: String { get }
    var method: HTTPMethod { get }
    var params: [String: Any] { get }
}

public extension BinanceRequest {
    var method: HTTPMethod {
        return .get
    }
    
    var params: [String: Any] {
        return [:]
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: endPoint, relativeTo: URL(string: BinanceApi.host.rawValue))!
        var request = try URLRequest(url: url, method: method)
        request = try URLEncoding.queryString.encode(request, with: params)
        return request
    }
}
