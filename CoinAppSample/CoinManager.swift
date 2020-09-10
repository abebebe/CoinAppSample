//
//  CoinManager.swift
//  CoinAppSample
//
//  Created by 阿部拓磨 on 2020/09/10.
//  Copyright © 2020 abetkma.com. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "84A7CE93-A68B-4412-9E14-A9695F180594"
    
    let currencyArray = ["USD","CNY","EUR","JPY","HKD"]
    
    var delegate:CoinManagerDelegate?
    
    
    func getCoinPrice(for currency:String){
        
        print(currency)
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            
            return lastPrice
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
