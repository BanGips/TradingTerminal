//
//  BinanceOrders.swift
//  BinanceAPI
//
//  Created by Sergei Kastyukovets on 3.02.23.
//

import Foundation

public enum BinanceOrderType: String, Codable {
    case limit = "LIMIT"
    case market = "MARKET"
}

public enum BinanceOrderSide: String, Codable {
    case buy = "BUY"
    case sell = "SELL"
}


public enum BinanceOrderStatus: String, Codable {
    case new = "NEW"
    case partial = "PARTIALLY_FILLED"
    case filled = "FILLED"
    case cancelled = "CANCELED" // Yes, this is correct.
    case pendingCancel = "PENDING_CANCEL"
    case rejected = "REJECTED"
    case expired = "EXPIRED"
}
