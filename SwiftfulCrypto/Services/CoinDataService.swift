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
    var coinSubscription:AnyCancellable?
    
    init(){
        getCoins()
    }
    
    private func getCoins(){
        guard let url = URL(string:"https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {return}
        
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on:DispatchQueue.global(qos: .default))
            .tryMap(handleOutput)
            .receive(on: DispatchQueue.main)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: {[weak self] returnedData in
                guard let self = self else{return}
                self.allCoins = returnedData
                self.coinSubscription?.cancel()
            }

    
    }
    
    private func handleOutput(output:URLSession.DataTaskPublisher.Output) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode <= 300 else { throw URLError(.badServerResponse) }
        return output.data
    }
}

