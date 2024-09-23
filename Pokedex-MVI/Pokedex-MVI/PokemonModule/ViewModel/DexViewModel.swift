//
//  DexViewModel.swift
//  Pokedex-MVI
//
//  Created by Jeong Deokho on 9/12/24.
//

import SwiftUI

// MARK: - Properties

@Observable
final class DexViewModel {
    
    @ObservationIgnored
    private let netWorkService: NetworkServiceDependency
    @ObservationIgnored
    private let coordinator: CoordinatorDependency
    @ObservationIgnored
    private let task: TaskWrapper
    
    init(netWorkService: NetworkServiceDependency = NetworkService(),
         task: TaskWrapper = RealTaskWrapper(),
         coordinator: CoordinatorDependency) {
        self.netWorkService = netWorkService
        self.task = task
        self.coordinator = coordinator
    }
    
    private(set) var state = DexState(
        originData: [],
        cellModels: [],
        filterModels: [],
        filterButtonIsSelected: false,
        isShowAlert: false,
        alertMessage: ""
    )
    
}

// MARK: - Constants

extension DexViewModel {
    private enum Constants {
        enum String {
            static let all = "All"
        }
    }
}

// MARK: - State

extension DexViewModel {
    struct DexState {
        let originData: [Pokemon]
        let cellModels: [DexCellModel]
        let filterModels: [FilterButtonModel]
        let filterButtonIsSelected: Bool
        let isShowAlert: Bool
        let alertMessage: String
        
        func copy(
            originData: [Pokemon]? = nil,
            cellModels: [DexCellModel]? = nil,
            filterModels: [FilterButtonModel]? = nil,
            filterButtonIsSelected: Bool? = nil,
            isShowAlert: Bool? = nil,
            alertMessage: String? = nil
        ) -> DexState {
            return DexState(
                originData: originData ?? self.originData,
                cellModels: cellModels ?? self.cellModels,
                filterModels: filterModels ?? self.filterModels,
                filterButtonIsSelected: filterButtonIsSelected ?? self.filterButtonIsSelected,
                isShowAlert: isShowAlert ?? self.isShowAlert,
                alertMessage: alertMessage ?? self.alertMessage
            )
        }
    }
}

// MARK: - Intent

extension DexViewModel {
    enum DexIntent {
        case fetchList
        case goToDetailView(DexCellModel)
        case fetchListSuccess([Pokemon?])
        case fetchListFailure(Error)
        case selectedFilter(String)
        case dismissAlert
    }
}

// MARK: - Helper Function

extension DexViewModel {
    func dispatch(_ intent: DexIntent) {
        //Log.debug("before Dex State", state)
        switch intent {
        case .fetchList:
            fetchList()
        case .goToDetailView(let dexCellModel):
            coordinator.push(destination: .pokemonDexDetail(dexCellModel))
        case .fetchListSuccess(let datas):
            let originData = datas.compactMap { $0 }
            let cellModels = originData.map { DexCellModel(data: $0) }
            var filterModels = Array(
                Set(cellModels.map { FilterButtonModel(title: $0.typeName, color: $0.backgroundColor, isSelected: false) })
            ).sorted { $0.title < $1.title }
            let firstFilter = FilterButtonModel(title: Constants.String.all, color: .black, isSelected: true)
            filterModels.insert(firstFilter, at: 0)
            state = state.copy(originData: originData, cellModels: cellModels, filterModels: filterModels)
        case .selectedFilter(let filterWord):
            let filteredOriginData = filterWord != Constants.String.all ? state.originData.filter { $0.type == filterWord } : state.originData
            state = state.copy(cellModels: filteredOriginData.map { DexCellModel(data: $0) })
        case .fetchListFailure(let error):
            state = state.copy(isShowAlert: true, alertMessage: error.localizedDescription)
        case .dismissAlert:
            state = state.copy(isShowAlert: false, alertMessage: "")
        }
        //Log.debug("after Dex State", state)
    }
    
    private func fetchList() {
        task.run { [weak self] in
            guard let self else { return }
            do {
                let data: [Pokemon?] = try await self.netWorkService.requestData(endPoint: PokemonEndPoint.getDex)
                Log.debug("Successfully retrieved Pokémon Dex List entries.", "List Count: \(data.count)")
                    self.dispatch(.fetchListSuccess(data))
            } catch {
                    self.dispatch(.fetchListFailure(error))
            }
        }
    }
}
