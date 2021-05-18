//
//  CitySelectionManager.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 3/30/21.
//

import UIKit
import CoreData


class CitySelectionManager:CitySelectionManagerProtocol {
    
    let persistentContainer: NSPersistentContainer
        
    //MARK:- Initialization
    
    required init(container:NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not reference app delegate")
        }
        self.init(container: delegate.persistentContainer)
    }
    
    //MARK:- CRUD operations
    
    
    /// Inserts a City Object into a desired managed context
    /// - Parameters:
    ///   - id: the city id in int32 format.
    ///   - name: the name of the city in string.
    ///   - state: the state where the city is located (only US) in string.
    ///   - country: the country in two letter symbols in string format
    ///   - lat: a dobule that represents the latitude of the city.
    ///   - lon: a dobuble that representes the longitude of the city.
    /// - Returns: a City casted that is a subclass of NSManagedObject.
    func insertCity(withId id:Int32, name:String, state:String, country:String, lat:Double, lon:Double) -> City? {

        let city = City(context: persistentContainer.viewContext)

        city.id = id
        city.name = name
        city.state = name
        city.country = country

        let coordinates = Coord(context: persistentContainer.viewContext)
        coordinates.lat = lat
        coordinates.lon = lon

        coordinates.city = city

        return city
    }
    
    
    /// Fetched the cities in the relationship
    /// - Returns: an optional array of the citites in study
    func fetchCitiesInStudy() -> [City]? {
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesInStudy")
        do {
            let retrievedCityInStudy = try persistentContainer.viewContext.fetch(fetch) as? [CitiesInStudy]
            let citiesInSudy = retrievedCityInStudy?.first
            guard let cities = citiesInSudy?.cities else { return nil }
            return Array(cities)
        } catch let error {
            print("It was not possible to fetch objects from the context. Error message: \(error)")
            return nil
        }
    }
        
    /// Removes City form the citiesInStudy relatioship.
    /// - Parameter city: the City object that is a subclass of NSManagedObject.
    func removeCityFromCitiesInStudy(cityIdToRemove:Int32) {
        
        // get the array of cities in study
        let citiesInStudy = fetchCitiesInStudy()
        
        // get the city that matches the id
        let cityToRemove = citiesInStudy?.first(where: { $0.id == cityIdToRemove })
        
        // remove the reference to the cities in study
        cityToRemove?.cityInStudy = nil
        
        try? persistentContainer.viewContext.save()
    }
    
    /// Saves the current context if is has changes.
    func save() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                fatalError("Save error \(error.localizedDescription)")
            }
        }
    }
}
