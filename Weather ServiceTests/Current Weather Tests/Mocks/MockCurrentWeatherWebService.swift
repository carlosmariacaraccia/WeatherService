//
//  MockCurrentWeatherWebService.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 3/30/21.
//

import Foundation
@testable import Weather_Service

class MockCurrentWeatherWebService:CurrentWeatherWebServiceProtocol {
    
    var isFetchWeatherDetailsCalled = false
    
    var isFetchCurrentWeatherCalled:Bool = false
    
    var failureErrorPassed:CurrentWeatherError?
    
    var extendedWeatherError:CurrentWeatherError?
    
    func fetchCurrentWeather(forCityId:String, completionHandler: @escaping (Result<CurrentWeatherResponse, CurrentWeatherError>) -> Void) {
        
        isFetchCurrentWeatherCalled = true
        
        if let responseError = failureErrorPassed {
            completionHandler(.failure(responseError))
        } else {
            let currentWeatherResponse = CurrentWeatherResponse(weather: nil, base: nil, main: nil, visibility: nil, wind: nil, clouds: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: nil, cod: nil)
            completionHandler(.success(currentWeatherResponse))
        }
    }
    
    func fetchExtendedWeather(forCityId cityId: String, completionHandler: @escaping (Result<ExtendedWeatherResponse, CurrentWeatherError>) -> Void) {
        
        isFetchWeatherDetailsCalled = true
        
        if let extendedWeatherError = extendedWeatherError {
            completionHandler(.failure(extendedWeatherError))
        } else {
            let extendedWeatherResponse = ExtendedWeatherResponse(cod: 200)
            completionHandler(.success(extendedWeatherResponse))
        }
    }

}
