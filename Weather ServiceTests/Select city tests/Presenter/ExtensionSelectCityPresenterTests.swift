//
//  ExtensionSelectCityPresenterTests.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 4/1/21.
//

import Foundation
import CoreData
import XCTest

@testable import Weather_Service


extension SelectCityPresenterTests {
    
    func createStubs() {
        
        func insertCityWith(id:Int32, name:String, state:String, country:String, lon:Double, lat:Double) -> City? {
            guard  let city = NSEntityDescription.insertNewObject(forEntityName: "City", into: mockPersistentContainer.viewContext) as? City else { return nil }
            city.id = id
            city.name = name
            city.state = state
            city.country = country
            
            let coord = Coord(context: mockPersistentContainer.viewContext)
            coord.lat = lat
            coord.lon = lon
            
            coord.city = city
            
            return city
        }

        _ = insertCityWith(id: 1950702, name: "Ketos Dua", state: "", country: "ID", lon: 106.540001, lat: -6.14694)
        _ = insertCityWith(id: 2111277, name: "Rifu", state: "", country: "JP", lon: 140.974442, lat: 38.323608)
        _ = insertCityWith(id: 2111429, name: "Omigawa", state: "", country: "JP", lon: 140.616669, lat: 35.849998)
        _ = insertCityWith(id: 2111687, name: "Narashino", state: "", country: "JP", lon: 140.033325, lat: 35.683331)
        
        // create an nsfetchrequest and find all its data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        
        let results = try? mockPersistentContainer.viewContext.fetch(request) as? [City]
        
        // we will save the first two items to cities in study
        let citiesInStudy = CitiesInStudy(context: mockPersistentContainer.viewContext)

        for i in 0..<2 {
            let cit = results![i]
            citiesInStudy.addToCities_(cit)
        }
        
        do {
            try mockPersistentContainer.viewContext.save()
        } catch let error {
            print("Could not save the object to the persistent container. \(error)")
        }
    }
    
    // To use in the tear down method
    func deleteAllData() {
        
        let fetchCities = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        let cities = try! mockPersistentContainer.viewContext.fetch(fetchCities) as? [City]
        for city in cities! {
            city.cityInStudy = nil
            mockPersistentContainer.viewContext.delete(city)
        }
        
        let fetchSelectedCities = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesInStudy")
        let selectedCities = try! mockPersistentContainer.viewContext.fetch(fetchSelectedCities)
        for case let selectedCity as NSManagedObject in selectedCities {
            mockPersistentContainer.viewContext.delete(selectedCity)
        }

        try! mockPersistentContainer.viewContext.save()
        
    }
    
    // An expectation is successful when we get notified
    func expectationForSaveNotification() -> XCTestExpectation {
        let expect = expectation(description: "Context Saved")
        waitForSavedNotification { (notification) in
            expect.fulfill()
        }
        return expect
    }
    
    func waitForSavedNotification(completeHandler: @escaping ((Notification)->()) ) {
        saveNotificationCompleteHandler = completeHandler
    }
    
    @objc func contextSaved( notification: Notification ) {
        saveNotificationCompleteHandler?(notification)
    }
    
}
