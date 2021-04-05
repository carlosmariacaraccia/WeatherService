//
//  SelectCityPresenter.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 4/1/21.
//

import Foundation
import CoreData

class SelectCityPresenter {
    
    private let storageService:SelectionCityStorageProtocol
    private let viewDelegate:SelectCityViewDelegateProtocol
    
    init(storageService:SelectionCityStorageProtocol, viewDelegate:SelectCityViewDelegateProtocol) {
        self.storageService = storageService
        self.viewDelegate = viewDelegate
    }
    
    func searchForCity(withString string:String) {
        let cities = storageService.searchForCities(containing: string)
        
        if let safeCities = cities {
            viewDelegate.didRecieveCities(cities: safeCities)
        } else {
            // TODO:- Handle the error appropiatelly.
           //viewDelegate.didReceiveError(error: )
        }
    }
    
    func addCityToCitiesInStudy(cityToAdd city:City) {
        storageService.addCityToCitiesInStudy(cityToAdd: city)
    }
    
}
