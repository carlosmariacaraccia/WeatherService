//
//  CitySelectionManagerProtocol.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 3/31/21.
//

import Foundation
import CoreData

protocol CitySelectionManagerProtocol:AnyObject {
    
    init(container:NSPersistentContainer)
    func insertCity(withId id:Int32, name:String, state:String, country:String, lat:Double, lon:Double) -> City?
    func removeCityFromCitiesInStudy(cityToRemove city:City)
    func fetchCitiesInStudy() -> [City]?
    func save()
}
