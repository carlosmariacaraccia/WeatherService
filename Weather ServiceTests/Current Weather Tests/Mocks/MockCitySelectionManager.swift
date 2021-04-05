//
//  MockCitySelectionManager.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 3/31/21.
//

import Foundation
import CoreData
@testable import Weather_Service


class MockCitySelectionManager:CitySelectionManagerProtocol {
    
    
    var isFetchedCitiesInStudyCalled:Bool = false
    var citiesToReturn:[City]?
    
    required init(container: NSPersistentContainer) {
        
    }
    
    func searchForCities(containing string: String) -> [City]? {
        return nil
    }

    
    func fetchCitiesInStudy() -> [City]? {
        isFetchedCitiesInStudyCalled = true
        guard let cities = citiesToReturn else { return nil }
        return cities
    }

    
    func insertCity(withId id: Int32, name: String, state: String, country: String, lat: Double, lon: Double) -> City? {
        return nil
    }
    
    func addCityToCitiesInStudy(cityToAdd city: City) {
    }
    
    func removeCityFromCitiesInStudy(cityToRemove city: City) {
    }
    
    func save() {
    }
    
    
}
