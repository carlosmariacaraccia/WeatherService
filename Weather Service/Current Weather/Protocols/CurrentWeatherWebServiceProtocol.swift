//
//  CurrentWeatherWebServiceProtocol.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 3/30/21.
//

import Foundation


protocol CurrentWeatherWebServiceProtocol:AnyObject {
    
    func fetchCurrentWeather(forCityId cityId: String, completionHandler:@escaping(Result<CurrentWeatherResponse,CurrentWeatherError>)->Void)
}
