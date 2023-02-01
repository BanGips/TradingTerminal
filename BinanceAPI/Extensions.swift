//
//  Extensions.swift
//  BinanceApi
//
//  Created by Sergei Kastyukovets on 28.01.23.
//

import Foundation
import Alamofire
import CryptoKit

extension Alamofire.DataRequest {
    
    func decodable<T: Decodable>(_ type: T.Type) -> DataTask<T> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return self.serializingDecodable(T.self, automaticallyCancelling: true, decoder: decoder)
    }
}

extension URL {
    
    func appendHost(relativeTo string: String) -> URL? {
        return URL(string: self.absoluteString, relativeTo: URL(string: string))
    }
}

extension String {
    
    func hmac(base64key key: String) -> String {
        let key = SymmetricKey(data: Data(key.utf8))
        let signature = HMAC<SHA256>.authenticationCode(for: Data(self.utf8), using: key)
        return signature.map { String(format: "%02x", $0)}.joined()
    }
}

public extension Date {
    var millisecondsSince1970: TimeInterval {
        return (timeIntervalSince1970 * 1000).rounded()
    }
}
