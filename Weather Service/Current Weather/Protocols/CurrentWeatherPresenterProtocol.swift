//
//  CurrentWeatherPresenterProtocol.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 4/1/21.
//

import Foundation


protocol CurrentWeatherPresenterProtocol:AnyObject {
    
    init(webService:WeatherWebServiceProtocol, viewDelegate:CurrentWeatherViewDelegateProtocol, selectionManager:CitySelectionManagerProtocol)
    
    func fetchNumberOfStoredCities() -> Int?
    func fetchWeatherForSeletedCities()
    func removeFromSelectedCities(cityId:Int32)
    
}
