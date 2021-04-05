//
//  MockCurrentWeatherPresenter.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 4/1/21.
//

import Foundation
@testable import Weather_Service

class MockCurrentWeatherPresenter:CurrentWeatherPresenterProtocol {

    var isFetchWeatherForSelectedCitiesCalled:Bool = false
    
    required init(webService: CurrentWeatherWebServiceProtocol, viewDelegate: CurrentWeatherViewDelegateProtocol, selectionManager: CitySelectionManagerProtocol) {
        
    }
    
    func fetchWeatherForSeletedCities() {
        
        isFetchWeatherForSelectedCitiesCalled = true
    }
    
    
}
