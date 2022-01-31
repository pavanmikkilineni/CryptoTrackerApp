//
//  CoinDataService.swift
//  SwiftfulCrypto
//
//  Created by Pavan Mikkilineni on 31/01/22.
//

import Foundation
import Combine

class CoinDataSource{
   
    @Published var allCoins:[CoinModel] = []
    private var coinSubscription:AnyCancellable?
    
    init(){
        getCoins()
    }
    
    private func getCoins(){
        guard let url = URL(string:"https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {return}
        
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion:NetworkingManager.handleCompletion){[weak self] returnedData in
                guard let self = self else{return}
                self.allCoins = returnedData
                self.coinSubscription?.cancel()
            }

    
    }
    
}

