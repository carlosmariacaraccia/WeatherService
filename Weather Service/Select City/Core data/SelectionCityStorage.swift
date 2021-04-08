//
//  SelectionCityStorage.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 4/1/21.
//

import Foundation
import CoreData


class SelectionCityStorage:SelectionCityStorageProtocol {
    
    private let persistentContainer:NSPersistentContainer
    
    required init(persistentContainer:NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    /// Function that checks in the persistent store for cities containing a portion of its name
    /// - Parameter string: the string that will be looked in the city name
    /// - Returns: an array of Cities
    func searchForCities(containing string:String) -> [City]? {
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        fetch.fetchLimit = 30
        fetch.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", string)
        fetch.predicate = predicate
        do {
            let retrievedCities = try persistentContainer.viewContext.fetch(fetch) as? [City]
            return retrievedCities
        } catch let error {
            print("It was not possible to fetch objects from the context. Error message: \(error)")
            return nil
        }
    }
    
    /// Adds a City object to the cities in study relationship.
    /// - Parameter city: the City object that is a subclass of NSManagedObject.
    func addCityToCitiesInStudy(cityToAdd city:City) {
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesInStudy")
        do {
            let retrievedCityInStudy = try persistentContainer.viewContext.fetch(fetch) as? [CitiesInStudy]
            let cityInStudy = retrievedCityInStudy?.first
            
            // if there is no citiesInStudy we create one (we are in the first case)
            if let citiesInStudy = cityInStudy {
                // before we add the city to the selected cities to display the weather we need to check if the city was already added.
                if city.cityInStudy == nil {
                    citiesInStudy.addToCities_(city)
                }
            } else {
                // This should only execute the first time
                let cityInStudy = CitiesInStudy(context: persistentContainer.viewContext)
                // before we add the city to the selected cities to display the weather we need to check if the city was already added.
                if city.cityInStudy == nil {
                    cityInStudy.addToCities_(city)
                }
            }
        } catch let error {
            print("It was not possible to fetch objects from the context. Error message: \(error)")
        }
        try? persistentContainer.viewContext.save()
    }

}
