//
//  BinanceApi.swift
//  BinanceApi
//
//  Created by Sergei Kastyukovets on 28.01.23.
//

import Foundation
import Alamofire
import KeychainSwift

public enum BinanceNetwork: String {
    case mainnet = "https://api.binance.com"
    case testnet = "https://testnet.binance.vision"
}

public class BinanceApi {

    private let session: Session
    private let adapter = Adapter()
    
    public static let apiKey = "apiKey"
    public static let secretKey = "secretKey"
    
    public static var host: BinanceNetwork {
        get {
            if let string = UserDefaults
                .standard
                .string(forKey: "BinanceApi.network"),
               let value = BinanceNetwork(rawValue: string) {
                return value
            } else {
                return .mainnet
            }
        }
        
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "BinanceApi.network")
        }
    }
    
    public init(host: BinanceNetwork = .mainnet) {
        Self.host = host
        
        var headers = AF.session.configuration.headers
        headers.remove(name: "Accept-Language")
        headers.add(name: "Content-Type", value: "application/json")

        let configuration = URLSessionConfiguration.af.default
        configuration.headers = headers
        
        self.session = Session(configuration: configuration, interceptor: adapter)
    }

    public func send<T: BinanceRequest>(_ request: T) async throws -> T.Response {
        return try await session.request(request).decodable(T.Response.self).value
    }
    
    class Adapter: RequestInterceptor {
        private let apiKey: String?
        private let secretKey: String?
        
        init() {
            let keychain = KeychainSwift()
            self.apiKey = keychain.get(BinanceApi.apiKey)
            self.secretKey = keychain.get(BinanceApi.secretKey)
        }
        
        func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
            var urlRequest = urlRequest
            let query = urlRequest.url?.query?.removingPercentEncoding ?? ""
            
            if !query.contains("timestamp=") {
                completion(.success(urlRequest))
                return
            }
            
            guard let apiKey, let secretKey else {
                completion(.failure(BinanceError.noApiKeySpecified))
                return
            }

            urlRequest.headers.add(.init(name: "X-Mbx-Apikey", value: apiKey))
            
            let signature = query.hmac(base64key: secretKey)
            
            do {
               urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["signature": signature])
            } catch {
                completion(.failure(BinanceError.paramsEncode))
            }
            
            completion(.success(urlRequest))
        }
    }
}
