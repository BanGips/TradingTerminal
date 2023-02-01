//
//  BinanceError.swift
//  BinanceAPI
//
//  Created by Sergei Kastyukovets on 1.02.23.
//

import Foundation

public enum BinanceError: Error {
    case noApiKeySpecified
    case paramsEncode
}
