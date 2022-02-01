//
//  PortfolioDataService.swift
//  SwiftfulCrypto
//
//  Created by Pavan Mikkilineni on 01/02/22.
//

import Foundation
import CoreData

class PortfolioDataService{
    
    @Published var savedEntities:[PortfolioEntity] = []

    
    private let container: NSPersistentContainer
    private let containerName:String = "PortfolioContainer"
    private let entityName:String = "PortfolioEntity"
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, err in
            if let err = err {
                print("Error Loading data... \(err.localizedDescription)")
            }
            self.getPortfolio()
        }
        
    }
    
    func updatePortfolio(coin:CoinModel,amount:Double){
        if let entity = savedEntities.first(where: { $0.coinID == coin.id}){
            if amount > 0{
                update(entity: entity, amount: amount)
            }else{
                delete(entity: entity)
            }
        }else{
            add(coin: coin, amount: amount)
        }
        
    }
    
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do{
           savedEntities = try container.viewContext.fetch(request)
        }catch let err{
            print("Error fetching Portfolio Entities... \(err.localizedDescription)")
        }
    }
    
    private func add(coin:CoinModel,amount:Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.amount = amount
        entity.coinID = coin.id
        applyChanges()
    }
    
    private func update(entity:PortfolioEntity,amount:Double){
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity:PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save(){
        do{
            try container.viewContext.save()
        }
        catch let err{
            print("Error Saving... \(err.localizedDescription)")
        }

    }
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
}
