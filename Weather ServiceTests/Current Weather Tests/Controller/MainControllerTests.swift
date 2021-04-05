//
//  MainControllerTests.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 3/30/21.
//

import XCTest
import CoreData
@testable import Weather_Service

class MainControllerTests: XCTestCase {
    
    var mockPersistentContainer:NSPersistentContainer!
    var mockWebService:MockCurrentWeatherWebService!
    var mockViewDelegate:MockCurrentWeatherViewDelegate!
    var mockSelectionManager:MockCitySelectionManager!
    var mockPresenter:MockCurrentWeatherPresenter!
    var sut:CurrentWeatherController!
    
    override func setUpWithError() throws {
        
        super.setUp()
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for:City.self)])!
        mockPersistentContainer = NSPersistentContainer(name: "OpenWeatherApp", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        mockPersistentContainer.persistentStoreDescriptions = [description]
        mockPersistentContainer.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )

            // Check if creating container wrong
            if let error = error {
                fatalError("Failed creating the NSInMemory store type \(error)")
            }
        }

        mockWebService = MockCurrentWeatherWebService()
        mockViewDelegate = MockCurrentWeatherViewDelegate()
        mockSelectionManager = MockCitySelectionManager(container: mockPersistentContainer)
        mockPresenter = MockCurrentWeatherPresenter(webService: mockWebService, viewDelegate: mockViewDelegate, selectionManager: mockSelectionManager)
        
        let layout = UICollectionViewFlowLayout()
        sut = CurrentWeatherController(collectionViewLayout: layout)
    }

    override func tearDownWithError() throws {
        
        mockWebService = nil
        mockViewDelegate = nil
        mockSelectionManager = nil
        mockPresenter = nil
        mockPersistentContainer = nil
        sut = nil
        super.tearDown()
    }

//    func testMainController_WhenCreated_CallsFetchWeatherForSeletedCitiesOnThePresenter() {
//
//
//        sut.currentWeatherPresenter = mockPresenter
//        sut.loadViewIfNeeded()
//        
//        XCTAssertTrue(mockPresenter.isFetchWeatherForSelectedCitiesCalled, "The fetchWeatherForSelectedCities() method was not called in the presenter.")
//        
//    }
//    
//    func testMainController_WhenCreated_ContainsActionButtonWithAnActionHookedToIt() {
//        
//        sut.loadViewIfNeeded()
//        
//        let actionButton = sut.actionButton
//        let actionsAssigned = actionButton.actions(forTarget: sut, forControlEvent: .touchUpInside)
//        
//        XCTAssertEqual(actionsAssigned?.count, Optional(1), "The action button in the main tab controller did not container 1 actions attached to it.")
//    }
//    
//    func testMainController_WhenCreated_ContainsActionButtonWithhandleActionButtonTap() throws {
//        
//        sut.loadViewIfNeeded()
//        
//        let actionButton = sut.actionButton
//        let actionsAssigned = try XCTUnwrap(actionButton.actions(forTarget: sut, forControlEvent: .touchUpInside), "The action button contains no actions attached to it.")
//        
//        XCTAssertTrue(actionsAssigned.contains("handleActionButtonTap"), "The action button in the main tab controller did not container 1 actions attached to it.")
//
//    }
    
    
    
}
