//
//  WeatherWebServiceProtocol.swift
//  Weather webservice
//
//  Created by Carlos Caraccia on 3/30/21.
//

import Foundation


protocol WeatherWebServiceProtocol:AnyObject {
    
    func fetchCurrentWeather(forCityId cityId: String, completionHandler:@escaping(Result<CurrentWeatherResponse,CurrentWeatherError>)->Void)
    
    func fetchExtendedWeather(forCityId cityId:String, completionHandler:@escaping(Result<ExtendedWeatherResponse,CurrentWeatherError>)->Void)
}
