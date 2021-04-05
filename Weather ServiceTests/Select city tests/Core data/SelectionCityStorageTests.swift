//
//  SelectionCityStorageTests.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 4/1/21.
//

import XCTest
import CoreData
@testable import Weather_Service

class SelectionCityStorageTests: XCTestCase {

    var managedObjectModel:NSManagedObjectModel!
    var mockPersistentContainer:NSPersistentContainer!
    var sut:SelectionCityStorage!
    
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
        sut = SelectionCityStorage(persistentContainer: mockPersistentContainer)
        createStubs()        
}

    override func tearDownWithError() throws {
        NotificationCenter.default.removeObserver(self)
        deleteAllData()
        sut = nil
        managedObjectModel = nil
        mockPersistentContainer = nil
    }

    func testSelectionCityStorage_WhenPassedAStringContainedByOneCityName_ReturnsAnArrayWithOneCity() {
        // Given
        let partiOfCityToSearch = "awa"
        // When
        let cities = sut.searchForCities(containing: partiOfCityToSearch)
        // Then
        XCTAssertEqual(cities?.count, Optional(1), "The city retrieved should be 1  but they where not.")
    }
    
    func testSelectionCityManager_SuccessFullyAddACityToCitiesInStudy_ShouldContain1Objects() {
        
        // get a desired city and add it.
        let id = 2111429
        var city:City?
        // create the fetch
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        let predicate = NSPredicate(format: "id == %i", id)
        fetch.predicate = predicate
        
        do {
            let retrievedCity = try mockPersistentContainer.viewContext.fetch(fetch) as? [City]
            // First assertion: we can have only one object per id, so if we have more the test should fail.
            
            if retrievedCity?.count != 1 {
                XCTFail("The result of the fetch request should contain only one City but it did not.")
            }
            city = retrievedCity?.first
        } catch let error {
            XCTFail("It was not possible to fetch objects from the context. Error message: \(error)")
        }

        // city should be safe to unwrap
        sut.addCityToCitiesInStudy(cityToAdd:city!)
        
        // now after adding the city we should retrieve it and check that the id is still the same.
        let fetchCitiesInStudy = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesInStudy")
        do {
            let retrievedCitiesInStudy = try mockPersistentContainer.viewContext.fetch(fetchCitiesInStudy) as? [CitiesInStudy]
            // First assertion: we can have only one object per id, so if we have more the test should fail.
            if retrievedCitiesInStudy?.count != 1 {
                XCTFail("The result of the fetch request should contain only one City but it did not.")
            }
            let id = retrievedCitiesInStudy?.first?.cities.first?.id
            XCTAssertEqual(id, Optional(id), "The result of the fetch request was not equal to the id.")
        } catch let error {
            XCTFail("It was not possible to fetch objects from the context. Error message: \(error)")
        }
    }

    
    //MARK:- Notification to use expectations on save
    var saveNotificationCompleteHandler: ((Notification)->())?

}
