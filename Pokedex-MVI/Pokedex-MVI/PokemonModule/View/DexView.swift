//
//  ContentView.swift
//  Pokedex-MVI
//
//  Created by Jeong Deokho on 9/10/24.
//

import SwiftUI

struct DexView: View {
    
    private enum Constants {
        enum String {
            static let retry = "Retry"
            static let Pokedex = "Pokedex"
        }
    }
    
    @State private var viewModel: DexViewModel
    @State private var isFirstAppear = true
    
    private let griditems = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(viewModel: DexViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.state.filterModels, id: \.title) { state in
                                FilterButton(state: state)
                                    .onTapGesture {
                                        viewModel.dispatch(.selectedFilter(state.title))
                                    }
                            }
                        }
                    }
                    .padding(.bottom, -10)
                    
                    LazyVGrid(columns: griditems, spacing: 20) {
                        ForEach(viewModel.state.cellModels, id: \.id) { state in
                            DexCellView(state: state)
                                .onTapGesture { _ in
                                    self.viewModel.dispatch(.goToDetailView(state))
                                }
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .alert(viewModel.state.alertMessage,
                   isPresented: Binding(
                    get: { viewModel.state.isShowAlert },
                    set: { newValue in
                        guard !newValue else { return }
                        viewModel.dispatch(.dismissAlert)
                    }
                   ),
                   actions: {
                return Button(Constants.String.retry) {
                    viewModel.dispatch(.fetchList)
                }
            })
            .onAppear {
                guard isFirstAppear else { return }
                viewModel.dispatch(.fetchList)
                isFirstAppear = false
            }
            .navigationTitle(Constants.String.Pokedex)
        }
    }
}

struct FilterButton: View {
    
    let state: FilterButtonModel
    
    var body: some View {
        Text(state.title)
            .padding(10)
            .background(state.color)
            .foregroundColor(.white)
            .clipShape(.rect(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(state.isSelected ? Color.black : Color.clear, lineWidth: 2)
            )
            .shadow(color: state.isSelected ? Color.black.opacity(0.3) : Color.clear, radius: 4, x: 0, y: 2)
            .padding(5)
    }
}
