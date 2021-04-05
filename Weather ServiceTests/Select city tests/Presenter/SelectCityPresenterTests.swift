//
//  SelectCityPresenterTests.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 4/1/21.
//

import XCTest
import CoreData
@testable import Weather_Service

class SelectCityPresenterTests: XCTestCase {
    
    var managedObjectModel:NSManagedObjectModel!
    var mockPersistentContainer:NSPersistentContainer!
    var mockStorage:MockSelectionCityStorage!
    var sut:SelectCityPresenter!
    var mockViewDelegate:MockSelectCityViewDelegate!
    
    override func setUpWithError() throws {
        
        managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for:City.self)])
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
        mockViewDelegate = MockSelectCityViewDelegate()
        mockStorage = MockSelectionCityStorage(persistentContainer: mockPersistentContainer)
        sut = SelectCityPresenter(storageService: mockStorage, viewDelegate: mockViewDelegate)
        createStubs()
        
    }

    override func tearDownWithError() throws {
        
        deleteAllData()
        sut = nil
        mockStorage = nil
        mockPersistentContainer = nil
        managedObjectModel = nil
        
    }
    
    func testSelectCityPresenter_WhenSearchForCitiesIsCalled_SearchCitiesIsCalledInTheMock() {
        
        let searchString = "a"
        let _ = sut.searchForCity(withString: searchString)
        
        XCTAssertTrue(mockStorage.isSearchCityCalled, "The searchForCity() method was not called from the storageCityService.")
    }
    
    
    func testSelectCityPresenter_WhenCitiesAreReturn_ShouldCallSuccessOnViewDelegate()throws {
        
        let searchString = "a"
        let city1 = City(context: mockPersistentContainer.viewContext)
        let city2 = City(context: mockPersistentContainer.viewContext)
        let city3 = City(context: mockPersistentContainer.viewContext)
        
        let cities = [city1, city2, city3]
        mockStorage.citiesToReturn = cities
        
        let myExpectation = expectation(description: "Call success on view delegate.")
        mockViewDelegate.expectation = myExpectation

        try XCTUnwrap(sut.searchForCity(withString: searchString), "The result of the call search for city was nil.")
        
        wait(for: [myExpectation], timeout: 3)
        
    }



    
    //MARK:- Notification to use expectations on save
    var saveNotificationCompleteHandler: ((Notification)->())?

}
