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

public struct BinanceSymbolsPriceRequest: BinanceRequest {
    public let endPoint: String = "/api/v3/ticker/price"
    public let symbols: String
    
    public init(symbols: [String]) {
        self.symbols = symbols.jsonRepresentable
    }
    
    public var params: [String : Any] {
        return ["symbols": symbols]
    }
    
    public typealias Response = [ResponseElement]
    
    public struct ResponseElement: Decodable {
        public let symbol, price: String
    }
}

public struct BinanceUserAssetRequest: BinanceSignedRequest {
    public let endPoint: String = "/sapi/v3/asset/getUserAsset"
    public let method: HTTPMethod = .post
    public let timestamp: TimeInterval
    
    public init(timestamp: Date = Date()) {
        self.timestamp = timestamp.millisecondsSince1970
    }
    
    public typealias Response = [ResponseElement]
    
    public struct ResponseElement: Decodable {
        public let asset, free, locked, freeze: String
        public let withdrawing, ipoable, btcValuation: String
    }
}

public struct BinanceAPIKeyPermissionRequest: BinanceSignedRequest {
    public let endPoint: String = "/sapi/v1/account/apiRestrictions"
    public let timestamp: TimeInterval
    
    public init(timestamp: Date = Date()) {
        self.timestamp = timestamp.millisecondsSince1970
    }
    
    public struct Response: Codable {
        let ipRestrict: Bool
        let createTime: Int
        let enableWithdrawals, enableInternalTransfer, permitsUniversalTransfer, enableVanillaOptions: Bool
        let enableReading, enableFutures, enableMargin, enableSpotAndMarginTrading: Bool
        let tradingAuthorityExpirationTime: Int
    }
}

public struct BinanceExchangeInformationRequest: BinanceRequest {
    public let endPoint: String = "/api/v3/exchangeInfo"
    public let permissions: String
    
    public var params: [String : Any] {
        return ["permissions": permissions]
    }
    
    public init(permissions: String = "SPOT") {
        self.permissions = permissions
    }
    
    public struct Response: Codable {
        public let timezone: String
        public let serverTime: Int
        public let symbols: [Symbol]
    }

    public struct Symbol: Codable {
        public let symbol, status, baseAsset: String
        public let baseAssetPrecision: Int
        public let quoteAsset: String
        public let quotePrecision, quoteAssetPrecision: Int
        public let orderTypes: [String]
        public let icebergAllowed, ocoAllowed, quoteOrderQtyMarketAllowed, allowTrailingStop: Bool
        public let cancelReplaceAllowed, isSpotTradingAllowed, isMarginTradingAllowed: Bool
        public let permissions: [String]
        public let defaultSelfTradePreventionMode: String
        public let allowedSelfTradePreventionModes: [String]
    }

}

public struct BinanceDailyAccountSnapshotRequest: BinanceSignedRequest {
    public let endPoint: String = "/sapi/v1/accountSnapshot"
    public let timestamp: TimeInterval
    public let type: String 
    
    public var params: [String : Any] {
        return ["type": type,
                "timestamp": timestamp]
    }
    
    public init(timestamp: Date = Date(), type: String = "SPOT") {
        self.timestamp = timestamp.millisecondsSince1970
        self.type = type
    }
    
    public struct Response: Codable {
        public let code: Int
        public let msg: String
        public let snapshotVos: [SnapshotVo]
    }

    public struct SnapshotVo: Codable {
        public let type: String
        public let updateTime: Date
        public let data: DataClass
    }

    public struct DataClass: Codable {
        public let totalAssetOfBtc: String
        public let balances: [Balance]
    }

    public struct Balance: Codable {
        public let asset, free, locked: String
    }

}
