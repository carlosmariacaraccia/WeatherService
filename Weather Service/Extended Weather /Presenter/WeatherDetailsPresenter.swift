//
//  WeatherDetailsPresenter.swift
//  Weather Service
//
//  Created by Carlos Caraccia on 4/7/21.
//

import Foundation


class WeatherDetailsPresenter {
    
    private let webservice:CurrentWeatherWebServiceProtocol
    private let viewDelegate:WeatherDetailsViewDelegateProtocol
    
    init(webservice:CurrentWeatherWebServiceProtocol, viewDelegate:WeatherDetailsViewDelegateProtocol) {
        self.webservice = webservice
        self.viewDelegate = viewDelegate
    }
    
    func fetchDetailedWeather(forCityId cityId: String) {
        
        webservice.fetchExtendedWeather(forCityId: cityId) { (result) in
            switch result {
            case .success(let extendedWeather):
                self.viewDelegate.didReceiveSuccess(forecast: extendedWeather)
            case .failure(let error):
                self.viewDelegate.didReceiveFailure(error: error)
            }
        }
        
    }
}
