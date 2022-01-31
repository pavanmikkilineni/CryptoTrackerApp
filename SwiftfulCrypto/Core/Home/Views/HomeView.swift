//
//  HomeView.swift
//  SwiftfulCrypto
//
//  Created by Pavan Mikkilineni on 31/01/22.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio:Bool = false
    
    var body: some View {
        ZStack{
            //background layer
            Color.theme.background
                .ignoresSafeArea()
            //content layer
            VStack{
                header
                Spacer(minLength: 0)
            }
            .padding(.horizontal)
            
        }
            
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
           HomeView()
                .navigationBarHidden(true)
        }
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
    
}
