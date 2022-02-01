//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by Pavan Mikkilineni on 31/01/22.
//

import Foundation
import Combine

class HomeViewModel:ObservableObject{
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var statistics:[StatisticModel] = []
    @Published var searchText:String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let coinDataService = CoinDataSource()
    private let marketDataService = MarketDataService()
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        
       $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                guard let self = self else{return}
                self.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink {  [weak self] returnedData  in
                guard let self = self else{return}
                self.statistics = returnedData
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text:String,coins:[CoinModel])->[CoinModel]{
        guard !text.isEmpty else{return coins}
        let lowercasedText = text.lowercased()
        let filteredCoins = coins.filter { (coin) -> Bool in
            return coin.name.contains(lowercasedText) ||
            coin.id.contains(lowercasedText) ||
            coin.symbol.contains(lowercasedText)
        }
        return filteredCoins
    }
    
    private func mapGlobalMarketData(data:MarketDataModel?)->[StatisticModel]{
        var stats:[StatisticModel] = []
        guard let data = data else{
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Voulme", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Protfolio", value: "$0.00", percentageChange: 0)
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
        
    }
    
    
}
