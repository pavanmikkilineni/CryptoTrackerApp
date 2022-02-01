//
//  MarketDataService.swift
//  SwiftfulCrypto
//
//  Created by Pavan Mikkilineni on 01/02/22.
//

import Foundation
import Combine

class MarketDataService{
    
    @Published var marketData:MarketDataModel? = nil
    private var marketDataSubscription:AnyCancellable?
    
    init(){
        getMarketData()
    }
    
    private func getMarketData(){
        guard let url = URL(string:"https://api.coingecko.com/api/v3/global") else {return}
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion:NetworkingManager.handleCompletion){[weak self] returnedData in
                guard let self = self else{return}
                self.marketData = returnedData.data
                self.marketDataSubscription?.cancel()
            }
    }
    
}
