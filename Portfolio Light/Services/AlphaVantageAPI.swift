//
//  AlphaVantageAPI.swift
//  Portfolio Light
//
//  Created by Christian Hjelmslund on 15/04/2019.
//  Copyright © 2019 Christian Hjelmslund. All rights reserved.
//

import Foundation

class AlphaVantageAPI {
    
    let key = Constants.AlphaVantageAPI.key
    
    
    static var myTimeSeries_TIME_SERIES_INTRADAY = "2019-04-18 14:10:00"
    static var myTimeSeries_TIME_SERIES_DAILY_ADJUSTED = "2019-04-18"
    
    
    struct Stocks_TIME_SERIES_DAILY_ADJUSTED: Decodable {
        var metaData: MetaData_TIME_SERIES_DAILY_ADJUSTED
        var series: Series_TIME_SERIES_DAILY_ADJUSTED
        
        enum CodingKeys: String, CodingKey {
            case metaData = "Meta Data"
            case series = "Time Series (Daily)"
        }
    }
    
    //_TIME_SERIES_DAILY_ADJUSTED
    struct MetaData_TIME_SERIES_DAILY_ADJUSTED: Decodable {
        let information: String
        let symbol: String
        let lastRefreshed: String
        let outputSize: String
        let timeZone: String
        
        enum CodingKeys: String, CodingKey {
            case information = "1. Information"
            case symbol = "2. Symbol"
            case lastRefreshed = "3. Last Refreshed"
            case outputSize = "4. Output Size"
            case timeZone = "5. Time Zone"
        }
    }
    
    struct Series_TIME_SERIES_DAILY_ADJUSTED: Decodable {
        var timeSeries: TimeSeries_TIME_SERIES_DAILY_ADJUSTED
        
        enum CodingKeys: String, CodingKey {
            case timeSeries
            
            init?(rawValue: String) {
                return nil
            }
            var rawValue: String {
                switch self {
                case .timeSeries:
                    return myTimeSeries_TIME_SERIES_DAILY_ADJUSTED
                }
            }
        }
    }
    
    struct TimeSeries_TIME_SERIES_DAILY_ADJUSTED: Decodable {
        let open: String
        let high: String
        let low: String
        let close: String
        let volume: String
        let adjustedClose: String
        let dividenAmount: String
        let splitCoefficient: String
        
        enum CodingKeys: String, CodingKey {
            case open = "1. open"
            case close = "4. close"
            case high = "2. high"
            case low = "3. low"
            case volume = "6. volume"
            case adjustedClose = "5. adjusted close"
            case dividenAmount = "7. dividend amount"
            case  splitCoefficient = "8. split coefficient"
        }
    }
    
    struct Stocks_TIME_SERIES_INTRADAY: Decodable {
        var metaData: MetaData_TIME_SERIES_INTRADAY
        var series: Series_TIME_SERIES_INTRADAY
        
        enum CodingKeys: String, CodingKey {
            case metaData = "Meta Data"
            case series = "Time Series (5min)"
        }
    }
    
    struct MetaData_TIME_SERIES_INTRADAY: Decodable {
        let information: String
        let symbol: String
        let lastRefreshed: String
        let interval: String
        let outputSize: String
        let timeZone: String
        
        enum CodingKeys: String, CodingKey {
            case information = "1. Information"
            case symbol = "2. Symbol"
            case lastRefreshed = "3. Last Refreshed"
            case interval = "4. Interval"
            case outputSize = "5. Output Size"
            case timeZone = "6. Time Zone"
        }
    }
    
    struct Series_TIME_SERIES_INTRADAY: Decodable {
        var timeSeries: TimeSeries_TIME_SERIES_INTRADAY
        
        enum CodingKeys: String, CodingKey {
            case timeSeries
            
            init?(rawValue: String) {
                return nil
            }
            var rawValue: String {
                switch self {
                case .timeSeries:
                    return myTimeSeries_TIME_SERIES_INTRADAY
                }
            }
        }
    }
  
    struct TimeSeries_TIME_SERIES_INTRADAY: Decodable {
        let open: String
        let high: String
        let low: String
        let close: String
        let volume: String
        
        enum CodingKeys: String, CodingKey {
            case open = "1. open"
            case close = "4. close"
            case high = "2. high"
            case low = "3. low"
            case volume = "5. volume"
        }
    }
    
    // For searching stocks
    struct Search: Decodable {
        let bestMatches: [Matches]
    }
    
    struct Matches: Decodable {
        let symbol: String
        let name: String
        let type: String
        let region: String
        let marketOpen: String
        let marketClose: String
        let timezone: String
        let currency: String
        let matchScore: String
        
        enum CodingKeys: String, CodingKey {
            case symbol = "1. symbol"
            case name = "2. name"
            case type = "3. type"
            case region = "4. region"
            case marketOpen = "5. marketOpen"
            case marketClose = "6. marketClose"
            case timezone = "7. timezone"
            case currency = "8. currency"
            case matchScore = "9. matchScore"
        }
    }
    
    func getStockPriceDate(stocksymbol: String, date: String, completion: @escaping (_ result: Double) -> Void){
        let stockUrl = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=\(stocksymbol)&outputsize=full&apikey=\(key)"
        guard let url = URL(string: stockUrl) else { return }
        AlphaVantageAPI.myTimeSeries_TIME_SERIES_DAILY_ADJUSTED = date
        print(AlphaVantageAPI.myTimeSeries_TIME_SERIES_DAILY_ADJUSTED)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let matches = try JSONDecoder().decode(Stocks_TIME_SERIES_DAILY_ADJUSTED.self, from: data)
                let series = matches.series
                let timeSeries = series.timeSeries
                print(timeSeries.close)
                guard let price = Double(timeSeries.close) else { return }
                print(price)
                completion(price)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
                completion(-1.0)
            }
            }.resume()
    
    }
    
    func getSearchValues(keyword: String, completion: @escaping (_ questions:[(name: String, symbol: String)]) -> Void) {
        
        let searchUrl = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keyword)&apikey=\(key)"
        guard let url = URL(string: searchUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
           
            do {
                let matches = try JSONDecoder().decode(Search.self, from: data)
                var companies: [(name: String, symbol: String)] = []
                for match in matches.bestMatches {
                    companies.append((name: match.name, symbol: match.symbol))
                }
                completion(companies)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
                completion([])
            }
        }.resume()
    }
}



