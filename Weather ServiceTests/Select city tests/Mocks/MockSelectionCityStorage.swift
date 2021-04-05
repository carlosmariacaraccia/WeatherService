//
//  MockSelectionCityStorage.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 4/1/21.
//

import Foundation
import CoreData
@testable import Weather_Service

class MockSelectionCityStorage: SelectionCityStorageProtocol {
    
    
    var isSearchCityCalled:Bool = false
    var citiesToReturn:[City]?
    
    required init(persistentContainer: NSPersistentContainer) {
        
    }
    
    func searchForCities(containing string: String) -> [City]? {
        isSearchCityCalled = true
        if citiesToReturn != nil {
            return citiesToReturn!
        } else {
            return nil
        }
    }
    
    func addCityToCitiesInStudy(cityToAdd city: City) {
        
    }

    
}
