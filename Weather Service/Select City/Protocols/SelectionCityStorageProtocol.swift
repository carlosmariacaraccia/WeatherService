//
//  SelectionCityStorageProtocol.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 4/1/21.
//

import Foundation
import CoreData

protocol SelectionCityStorageProtocol:AnyObject {
    
    init(persistentContainer:NSPersistentContainer)
    
    func searchForCities(containing string:String) -> [City]?
    func addCityToCitiesInStudy(cityToAdd city:City)
}
