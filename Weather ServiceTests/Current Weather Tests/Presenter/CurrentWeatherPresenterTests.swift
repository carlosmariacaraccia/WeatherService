//
//  CurrentWeatherPresenterTests.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 3/30/21.
//

import XCTest
@testable import Weather_Service
import CoreData

class CurrentWeatherPresenterTests: XCTestCase {
    
    var managedObjectModel:NSManagedObjectModel!
    var mockPersistentContainer:NSPersistentContainer!
    var mockSelectionManager:MockCitySelectionManager!
    var mockWebService:MockCurrentWeatherWebService!
    var mockViewDelegate:MockCurrentWeatherViewDelegate!
    var sut:CurrentWeatherPresenter!
    
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

        mockWebService = MockCurrentWeatherWebService()
        mockViewDelegate = MockCurrentWeatherViewDelegate()
        mockSelectionManager = MockCitySelectionManager(container: mockPersistentContainer)
        sut = CurrentWeatherPresenter(webService: mockWebService, viewDelegate: mockViewDelegate, selectionManager: mockSelectionManager)
    }
    
    override func tearDownWithError() throws {
        deleteAllData()
        mockWebService = nil
        mockViewDelegate = nil
        mockSelectionManager = nil
        mockPersistentContainer = nil
        managedObjectModel = nil
        sut = nil
    }
    
    func testCurrentWeatherPresenter_WhenFetchWeatherForSeletedCitiesIsCalled_CallsFetchSelectedCities() {
        
        
        sut.fetchWeatherForSeletedCities()
        
        XCTAssertTrue(mockSelectionManager.isFetchedCitiesInStudyCalled, "The fetchSelectedCities() method was not called in the CitiesSelectionManager")
    }
    
    func testCurrentWeatherPresenter_WhenFetchWeatherForSeletedCitiesIsCalled_CallesFetchCurrenWeatherWebServiceForEachCity() {
        
        let city1 = City(context: mockPersistentContainer.viewContext)
        let city2 = City(context: mockPersistentContainer.viewContext)
        let city3 = City(context: mockPersistentContainer.viewContext)
        
        let cities = [city1, city2, city3]
        mockSelectionManager.citiesToReturn = cities
        
        sut.fetchWeatherForSeletedCities()
        XCTAssertTrue(mockWebService.isFetchCurrentWeatherCalled, "The fetchCurrentWeather() method in the web service was not called.")
    }
    
    func testCurrentWeatherPresenter_WhenASuccessFullResponseIsReceived_CallsSuccessOnViewDelegate() {
        
        let city1 = City(context: mockPersistentContainer.viewContext)
        let city2 = City(context: mockPersistentContainer.viewContext)
        let city3 = City(context: mockPersistentContainer.viewContext)
        
        let cities = [city1, city2, city3]
        mockSelectionManager.citiesToReturn = cities

        let newExpectation = expectation(description: "Calls success on view delegate.")
        mockViewDelegate.myExpectation = newExpectation
        
        sut.fetchWeatherForSeletedCities()
        
        wait(for: [newExpectation], timeout: 3)
    }
    
    func testCurrentWeahterPresenter_WhenAnUnSuccessfulResopnseIsReceived_CallsFailureOnViewDelegate() {
        
        let city1 = City(context: mockPersistentContainer.viewContext)
        let city2 = City(context: mockPersistentContainer.viewContext)
        let city3 = City(context: mockPersistentContainer.viewContext)
        
        let cities = [city1, city2, city3]
        mockSelectionManager.citiesToReturn = cities

        let newExpectation = expectation(description: "Calls failure on view delegate.")
        mockViewDelegate.failureExpectation = newExpectation
        mockWebService.failureErrorPassed = CurrentWeatherError.ErrorInResponse(description: "Problem in the response.")
        sut.fetchWeatherForSeletedCities()
        
        wait(for: [newExpectation], timeout: 3)

    }
}
