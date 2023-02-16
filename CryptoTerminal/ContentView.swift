//
//  ContentView.swift
//  CryptoTerminal
//
//  Created by Sergei Kastyukovets on 30.01.23.
//

import SwiftUI
import BinanceAPI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .task {
            let api = BinanceApi()
            let r = BinanceDailyAccountSnapshotRequest()
//            let r = BinanceSymbolPriceRequest(symbol: "BTCUSDT")
            do {
                let result = try await api.send(r)
                print(result)
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
