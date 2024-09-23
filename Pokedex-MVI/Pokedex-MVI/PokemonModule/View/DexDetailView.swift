//
//  DexDetailView.swift
//  Pokedex-MVI
//
//  Created by Jeong Deokho on 9/11/24.
//

import SwiftUI

struct DexDetailView: View {
    
    let state: DexCellModel
    
    var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                ZStack {
                    state.backgroundColor
                    CachedAsyncImage(url: state.imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding(.top, 100)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 200, height: 200)
                    }
                }
                .frame(height: 300)
                
                Text(state.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading, 10)
            
                Text(state.typeName)
                    .font(.headline)
                    .padding(.leading, 10)
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
        }
}

