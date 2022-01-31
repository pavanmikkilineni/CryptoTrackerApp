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
    @Published var searchText:String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let dataService = CoinDataSource()
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        
       $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                guard let self = self else{return}
                self.allCoins = returnedCoins
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
    
}
