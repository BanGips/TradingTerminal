//
//  BinanceRequests.swift
//  BinanceApi
//
//  Created by Sergei Kastyukovets on 28.01.23.
//

import Foundation
import Alamofire
import KeychainSwift

public struct BinancePingRequest: BinanceRequest {
    public let endPoint = "/api/v3/ping"

    public init() { }
    
    public struct Response: Decodable { }
}

public struct BinanceTimeRequest: BinanceRequest {
    public let endPoint: String = "/api/v3/time"
    
    public init() { }
    
    public struct Response: Decodable {
        public let serverTime: Date
        public var localTime: Date = Date()
        
        public var delta: TimeInterval {
            localTime.distance(to: serverTime)
        }
        
        enum CodingKeys: CodingKey {
            case serverTime
        }
    }
}

public struct BinanceSystemStatusRequest: BinanceRequest {
    public let endPoint: String = "/sapi/v1/system/status"
    
    public init() { }
    
    public struct Response: Decodable {
        public let status: Int
        public let msg: String
    }
}

public struct BinanceSymbolPriceRequest: BinanceRequest {
    public let endPoint: String = "/api/v3/ticker/price"
    public let symbol: String
    
    public init(symbol: String) {
        self.symbol = symbol
    }
    
    public var params: [String : Any] {
        return ["symbol": symbol]
    }
    
    public struct Response: Decodable {
        public let symbol, price: String
    }
}

protocol BinanceSignedRequest: BinanceRequest {
    var timestamp: TimeInterval { get }
}

public struct BinanceUserAssetRequest: BinanceSignedRequest {
    public let endPoint: String = "/sapi/v3/asset/getUserAsset"
    public var method: HTTPMethod = .post
    public var timestamp: TimeInterval
    
    public var params: [String : Any] {
        return ["timestamp": timestamp]
    }
    
    public init(timestamp: Date = Date()) {
        self.timestamp = timestamp.millisecondsSince1970
    }
    
    
    public typealias Response = [ResponseElement]
    
    public struct ResponseElement: Decodable {
        public let asset, free, locked, freeze: String
        public let withdrawing, ipoable, btcValuation: String
    }
    
    
    
}

