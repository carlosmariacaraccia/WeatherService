//
//  CurrentWeatherPresenterExtensin.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 3/31/21.
//

import Foundation
import CoreData

extension CurrentWeatherPresenterTests {
    
    func deleteAllData() {
        
        let fetchCities = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        let cities = try! mockPersistentContainer.viewContext.fetch(fetchCities)
        for case let city as NSManagedObject in cities {
            mockPersistentContainer.viewContext.delete(city)
        }
        
        let fetchSelectedCities = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesInStudy")
        let selectedCities = try! mockPersistentContainer.viewContext.fetch(fetchSelectedCities)
        for case let selectedCity as NSManagedObject in selectedCities {
            mockPersistentContainer.viewContext.delete(selectedCity)
        }

        try! mockPersistentContainer.viewContext.save()
        
    }

}
