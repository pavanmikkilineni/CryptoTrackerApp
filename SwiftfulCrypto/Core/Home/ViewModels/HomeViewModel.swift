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
    
    private var cancellables = Set<AnyCancellable>()
    private let dataService = CoinDataSource()
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        dataService.$allCoins
            .sink { [weak self] returnedData in
                guard let self = self else{return}
                self.allCoins = returnedData
            }
            .store(in: &cancellables)
    }
    
}
