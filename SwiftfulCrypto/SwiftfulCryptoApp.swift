//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by Pavan Mikkilineni on 31/01/22.
//

import SwiftUI

@main
struct SwiftfulCryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }

}
