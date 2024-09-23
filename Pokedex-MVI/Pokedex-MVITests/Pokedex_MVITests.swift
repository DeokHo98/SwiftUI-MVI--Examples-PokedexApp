//
//  Pokedex_MVITests.swift
//  Pokedex-MVITests
//
//  Created by Jeong Deokho on 9/12/24.
//

import XCTest
@testable import Pokedex_MVI

final class Pokedex_MVITests: XCTestCase {
    
    var networkService: MockNetworkService!
    var task: MockTaskWrapper!
    var coordinator: MockCoordinator!
    var viewModel: DexViewModel!
    
    override func setUp() {
        networkService = MockNetworkService()
        task = MockTaskWrapper()
        coordinator = MockCoordinator()
        viewModel = DexViewModel(
            netWorkService: networkService,
            task: task,
            coordinator: coordinator
        )
    }
    
    override func tearDown() {
        networkService = nil
        task = nil
        coordinator = nil
        viewModel = nil
    }
    
    func test_fetchListSuccess() {
        // given
        let expectation = XCTestExpectation()
        let mockModels: [Pokemon?] = [
            Pokemon(id: 1, name: "name1", imageURL: "imageURL1", type: "fire"),
            Pokemon(id: 2, name: "name2", imageURL: "imageURL2", type: "water")
        ]
        networkService.setModel(mockModels)
        task.runHandler = {
            expectation.fulfill()
        }
  
        // when
        self.viewModel.dispatch(.fetchList)
        wait(for: [expectation], timeout: 1)
        
        // then
        XCTAssertEqual(viewModel.state.cellModels.count, 2)
        XCTAssertEqual(viewModel.state.cellModels[0].id, 1)
        XCTAssertEqual(viewModel.state.cellModels[1].id, 2)
        XCTAssertEqual(viewModel.state.cellModels[0].name, "name1")
        XCTAssertEqual(viewModel.state.cellModels[1].name, "name2")
        XCTAssertEqual(viewModel.state.cellModels[0].imageURL, "imageURL1")
        XCTAssertEqual(viewModel.state.cellModels[1].imageURL, "imageURL2")
        XCTAssertEqual(viewModel.state.cellModels[0].typeName, "fire")
        XCTAssertEqual(viewModel.state.cellModels[1].typeName, "water")
        XCTAssertEqual(viewModel.state.cellModels[0].backgroundColor, .red)
        XCTAssertEqual(viewModel.state.cellModels[1].backgroundColor, .blue)
    }
    
    func test_fetchListFailure() {
        // given
        let expectation = XCTestExpectation()
        networkService.setError(.defaultError)
        task.runHandler = {
            expectation.fulfill()
        }
        
        // when
        viewModel.dispatch(.fetchList)
        wait(for: [expectation], timeout: 1)
        
        // then
        XCTAssertEqual(viewModel.state.isShowAlert, true)
        XCTAssertEqual(viewModel.state.alertMessage, MockError.defaultError.localizedDescription)
    }
    
    func test_set_filterModels() {
        // given
        let expectation = XCTestExpectation()
        let mockModels: [Pokemon?] = [
            Pokemon(id: 1, name: "name1", imageURL: "imageURL1", type: "fire"),
            Pokemon(id: 2, name: "name2", imageURL: "imageURL2", type: "fire"),
            Pokemon(id: 3, name: "name3", imageURL: "imageURL3", type: "fire"),
            Pokemon(id: 4, name: "name4", imageURL: "imageURL4", type: "fire"),
            Pokemon(id: 5, name: "name5", imageURL: "imageURL5", type: "water")
        ]
        networkService.setModel(mockModels)
        task.runHandler = {
            expectation.fulfill()
        }
        
        // when
        viewModel.dispatch(.fetchList)
        wait(for: [expectation], timeout: 1)
        
        // then
        XCTAssertEqual(viewModel.state.filterModels[0].title, "All")
        XCTAssertEqual(viewModel.state.filterModels[0].color, .black)
        XCTAssertEqual(viewModel.state.filterModels[1].title, "fire")
        XCTAssertEqual(viewModel.state.filterModels[1].color, .red)
        XCTAssertEqual(viewModel.state.filterModels[2].title, "water")
        XCTAssertEqual(viewModel.state.filterModels[2].color, .blue)
    }
    
    func test_selectedFilter() {
        // given
        let expectation = XCTestExpectation()
        let mockModels: [Pokemon?] = [
            Pokemon(id: 1, name: "name1", imageURL: "imageURL1", type: "fire"),
            Pokemon(id: 2, name: "name2", imageURL: "imageURL2", type: "water")
        ]
        networkService.setModel(mockModels)
        task.runHandler = {
            expectation.fulfill()
        }
        
        // when
        viewModel.dispatch(.fetchList)
        wait(for: [expectation], timeout: 1)
        viewModel.dispatch(.selectedFilter("water"))
        
        // then
        XCTAssertEqual(viewModel.state.cellModels.count, 1)
        XCTAssertEqual(viewModel.state.cellModels[0].id, 2)
        XCTAssertEqual(viewModel.state.cellModels[0].name, "name2")
        XCTAssertEqual(viewModel.state.cellModels[0].imageURL, "imageURL2")
        XCTAssertEqual(viewModel.state.cellModels[0].typeName, "water")
        XCTAssertEqual(viewModel.state.cellModels[0].backgroundColor, .blue)
    }

     func test_goToDetailView() {
         // given
         let mockCellModel = DexCellModel(data: Pokemon(id: 1, name: "name1", imageURL: "imageURL1", type: "fire"))
         
         // when
         viewModel.dispatch(.goToDetailView(mockCellModel))
         
         // then
         XCTAssertEqual(coordinator.pushDestination.first, .pokemonDexDetail(mockCellModel))
     }
    
    func test_dismissAlert() {
        viewModel.dispatch(.fetchListFailure(MockError.defaultError))
        XCTAssertTrue(viewModel.state.isShowAlert)
        XCTAssertFalse(viewModel.state.alertMessage.isEmpty)
        
        viewModel.dispatch(.dismissAlert)
        XCTAssertFalse(viewModel.state.isShowAlert)
        XCTAssertEqual(viewModel.state.alertMessage, "")
    }
}
