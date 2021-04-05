//
//  CurrentWeatherPresenterProtocol.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 4/1/21.
//

import Foundation


protocol CurrentWeatherPresenterProtocol:AnyObject {
    
    init(webService:CurrentWeatherWebServiceProtocol, viewDelegate:CurrentWeatherViewDelegateProtocol, selectionManager:CitySelectionManagerProtocol)
    
    func fetchWeatherForSeletedCities()
    
}
