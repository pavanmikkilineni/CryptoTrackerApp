//
//  CoinImageService.swift
//  SwiftfulCrypto
//
//  Created by Pavan Mikkilineni on 31/01/22.
//

import Foundation
import UIKit
import Combine

class CoinImageService{
    
    @Published var image:UIImage? = nil
    private var coinImageSubscription:AnyCancellable?
    private let coin:CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName:String = "coin_images"
    
    init(coin:CoinModel){
        self.coin = coin
        getCoinImage()
    }
    
    func getCoinImage(){
        if let image = fileManager.getImage(imageName: coin.id, folderName: folderName){
            self.image = image
        }else{
            downloadCoinImage()
        }
        
    }
    
    private func downloadCoinImage(){
        
        guard let url = URL(string:coin.image) else {return}
        
        coinImageSubscription = NetworkingManager.download(url: url)
            .tryMap({(data)->UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion:NetworkingManager.handleCompletion){[weak self] returnedData in
                guard let self = self else{return}
                self.image = returnedData
                self.coinImageSubscription?.cancel()
                self.fileManager.saveImage(image: returnedData!, imageName: self.coin.id, folderName: self.folderName)
            }

    }
    
}
