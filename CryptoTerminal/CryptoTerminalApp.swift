//
//  CryptoTerminalApp.swift
//  CryptoTerminal
//
//  Created by Sergei Kastyukovets on 30.01.23.
//

import SwiftUI
import KeychainSwift
import BinanceAPI

@main
struct CryptoTerminalApp: App {
    
    init() {
        let keychain = KeychainSwift()
        if keychain.get(BinanceApi.apiKey) == nil &&  keychain.get(BinanceApi.secretKey) == nil {
            
            keychain.set("iqFDHdWG5fUuWGVMLfyo4JLPSElQACH2TxkbyVjGiyTm3ljEZz5SWLY5Om8ntdI8", forKey: BinanceApi.apiKey)
            keychain.set("o1rHtXIfqqRdGRnbokSEt39mryZ6JmXpIvY96t3CqSK2S2FRTOVvz7qbPmx76ly4", forKey: BinanceApi.secretKey)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
