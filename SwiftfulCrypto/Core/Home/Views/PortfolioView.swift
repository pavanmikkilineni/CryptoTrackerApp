//
//  PortfolioView.swift
//  SwiftfulCrypto
//
//  Created by Pavan Mikkilineni on 01/02/22.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm:HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedCoin:CoinModel? = nil
    @State private var quantityText:String = ""
    @State private var showCheckMark:Bool = false
    @FocusState private var isFocused:Bool

    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment:.leading,spacing:0){
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    if selectedCoin != nil{
                        VStack(spacing:20){
                            HStack{
                                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                                Spacer()
                                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
                            }
                            Divider()
                            HStack{
                                Text("Amount in your portfolio:")
                                Spacer()
                                TextField("Ex: 1.4",text:$quantityText)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                            }
                            Divider()
                            HStack{
                                Text("Current Value:")
                                Spacer()
                                Text(getCurrentValue().asCurrencyWith2Decimals())
                            }
                            
                        }
                        .padding()
                        .font(.headline)
                    }
                }
                
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action:{
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                }
                ToolbarItem(placement:.navigationBarTrailing){
                    HStack(spacing:10){
                        Image(systemName:"checkmark")
                            .opacity(showCheckMark ? 1.0 : 0.0)
                        Button(action:{saveButtonPressed()},label:{Text("Save".uppercased())})
                            .opacity(
                                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0
                            )
                        
                    }
                    .font(.headline)
                }
            })
            .onChange(of: vm.searchText) { newValue in
                if newValue == ""{
                    removeSelectedCoin()
                }
            }
        }
        
    }
    
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}

extension PortfolioView{
    private var coinLogoList:some View{
        ScrollView(.horizontal,showsIndicators: true) {
            LazyHStack(spacing:10){
                ForEach(vm.allCoins){ coin in
                    CoinLogoView(coin: coin)
                        .frame(width:75)
                        .padding(4)
                        .onTapGesture{
                            withAnimation(.easeIn){
                                updateSelectedCoin(coin:coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke( selectedCoin?.id == coin.id ? Color.theme.green : Color.clear,lineWidth: 1)
                        )
                }
            }
        }
        .padding(.vertical,4)
        .padding(.leading)
    }
    
    private func updateSelectedCoin(coin:CoinModel){
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first(where: {$0.id == coin.id}),
            let amount = portfolioCoin.currentHoldings {
                quantityText = "\(amount)"
            }else{
                 quantityText = ""
             }
    }
    
    private func getCurrentValue()->Double{
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButtonPressed(){
        guard let coin = selectedCoin,
              let amount = Double(quantityText)
        else{return}
        
        vm.updatePortfolio(coin: coin, amount: amount)
        
        withAnimation(.easeIn){
            showCheckMark = true
            removeSelectedCoin()
        }

        isFocused = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            withAnimation(.easeIn){
                showCheckMark = false
            }
        }
        
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
}
