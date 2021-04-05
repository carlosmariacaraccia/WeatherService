//
//  SelectionCityManagerTests.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 3/30/21.
//

import XCTest
import CoreData
@testable import Weather_Service


class CitySelectionManagerTests: XCTestCase {
    
    var managedObjectModel:NSManagedObjectModel!
    var mockPersistentContainer:NSPersistentContainer!
    var sut:CitySelectionManager!

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
        
        createStubs()
        
        sut = CitySelectionManager(container: mockPersistentContainer)
        
        // subscribe to notification center to listen to changes in the context
        NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)), name: .NSManagedObjectContextDidSave, object: nil)
    }

    override func tearDownWithError() throws {
        NotificationCenter.default.removeObserver(self)
        deleteAllData()
        sut = nil
        managedObjectModel = nil
        mockPersistentContainer = nil
    }
    
    func testSelectionCityManager_WhenCreateACity_IsNotNil() {
        
        let city = sut.insertCity(withId: 2111704, name: "Namie", state: "", country: "JP", lat: 37.48333, lon: 141.0)
        
        XCTAssertNotNil(city, "The created City() was nil when it was not suppossed to.")
    }
    
    func testSelectionCityManager_UponASuccessfulInsertionOf4ObjectsWhenFetched_ShouldReturn4Objects() {
        
        // CreateStubs() adds 4 cities and the first 2 to the Citites in study relationship.
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        do {
            let cities = try mockPersistentContainer.viewContext.fetch(fetch) as? [City]
            XCTAssertEqual(cities?.count, Optional(4), "The result of the fetch should be 4 but we find a different number.")
        } catch let error {
            XCTFail("It was not possible to fetch objects from the context. Error message: \(error)")
        }
    }
    
    func testSelectionCityManager_UponASuccessfullInsertionOf2ObjectsInSelectedCities_ShouldContain2Objects() {
        
        // CreateStubs() adds 4 cities and the first 2 to the Citites in study relationship.
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesInStudy")
        do {
            let selection = try mockPersistentContainer.viewContext.fetch(fetch).first as? CitiesInStudy
            
            XCTAssertEqual(selection?.cities.count, Optional(2), "The result of the fetch request should contain a CitiesInStudy object with a relatinship to 2 objects in the City entity but it did not.")
        } catch let error {
            XCTFail("It was not possible to fetch objects from the context. Error message: \(error)")
        }
    }
    
    
    func testSelectionCityManager_WhenTryingToRemoveACityFromCitiesInStudy_ShouldBeRemoved() {
        

        var city:City?
        // create the fetch
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        let predicate = NSPredicate(format: "cityInStudy != nil")
        fetch.predicate = predicate
        
        do {
            let retrievedCity = try mockPersistentContainer.viewContext.fetch(fetch) as? [City]
            // First assertion: we can have only one object per id, so if we have more the test should fail.
            city = retrievedCity?.first
            
        } catch let error {
            XCTFail("It was not possible to fetch objects from the context. Error message: \(error)")
        }

        sut.removeCityFromCitiesInStudy(cityToRemove: city!)
        try? mockPersistentContainer.viewContext.save() 
        // now after removing the city we should count 0
        let fetchCitiesInStudy = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesInStudy")
        do {
            let retrievedCitiesInStudy = try mockPersistentContainer.viewContext.fetch(fetchCitiesInStudy) as? [CitiesInStudy]
            let cities = retrievedCitiesInStudy?.first?.cities.count
            XCTAssertEqual(cities, Optional(1), "The cities array inside the CitiesInStudy object should contain 1 object, but it did not.")
        } catch let error {
            XCTFail("It was not possible to fetch objects from the context. Error message: \(error)")
        }
    }
    
    //MARK:- Notification to use expectations on save
    var saveNotificationCompleteHandler: ((Notification)->())?
}
