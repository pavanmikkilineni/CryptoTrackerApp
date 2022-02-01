//
//  SearchBarView.swift
//  SwiftfulCrypto
//
//  Created by Pavan Mikkilineni on 31/01/22.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText:String
    @FocusState private var isFoucsed:Bool
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent
                )
            TextField("Search by name or symbol...",text:$searchText)
                .focused($isFoucsed)
                .foregroundColor(Color.theme.accent)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x:10)
                        .foregroundColor(
                            searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent
                        )
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture(perform: {
                            searchText = ""
                            isFoucsed = false
                        })
                    ,alignment:.trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.15), radius: 10, x: 0, y: 0)
        )
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
        }
        
    }
}
