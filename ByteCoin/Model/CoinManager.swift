//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation


protocol CoinManagerDelegate{
    func didUpdateCoinPrice(price:String, currency:String)
    func didFailError(error:Error)
}


struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "9B22DD49-762E-4DE9-91C7-FD8509DA606D"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency:String){
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailError(error: error!)
                    return
                }
                if let safeData = data{
                    if let bitCoinPrice = parseJSON(safeData){
                        let priicng = String(format: "%.2f", bitCoinPrice)
                        self.delegate?.didUpdateCoinPrice(price: priicng, currency: currency)
                        
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data:Data) -> Double?{
        let decoder = JSONDecoder()
        do{
           
            let decodData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodData.rate
            print(lastPrice)
            
            return lastPrice
        }catch{
            print(error)
            return nil
        }
        
    }
    
}
