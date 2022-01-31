//
//  HomeView.swift
//  SwiftfulCrypto
//
//  Created by Pavan Mikkilineni on 31/01/22.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio:Bool = false
    @EnvironmentObject private var vm:HomeViewModel
    
    var body: some View {
        ZStack{
            //background layer
            Color.theme.background
                .ignoresSafeArea()
            //content layer
            VStack{
                header
                SearchBarView(searchText: $vm.searchText)
                columnTitles
                if !showPortfolio{
                    allCoinsList
                      .transition(.move(edge: .leading))
                }
                if showPortfolio{
                   portfolioCoinsList
                    .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal)
            
        }
            
    }
}

// MARK: PREVIEWS
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
           HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.vm)
    }
}

extension HomeView{
    
    private var header:some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none,value:showPortfolio)
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Protfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none,value:showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()
                    }
                }
        }
    }
    
    private var allCoinsList:some View{
        List{
            ForEach(vm.allCoins){ coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsList:some View{
        List{
            ForEach(vm.portfolioCoins){ coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles:some View{
        HStack{
            Text("Coin")
            Spacer()
            if showPortfolio{
               Text("Holdings")
            }
            Text("Price")
                .frame(width:UIScreen.main.bounds.width/3.5,alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
}
