//
//  CurrentWeatherPresenter.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 3/30/21.
//

import Foundation
import CoreData

class CurrentWeatherPresenter:CurrentWeatherPresenterProtocol {
    
    private let webService:WeatherWebServiceProtocol
    private let viewDelegate:CurrentWeatherViewDelegateProtocol
    private let selectionManager:CitySelectionManagerProtocol
    
    // TODO: - Change this annoying error name for one representative and change its type to be a bool, there is no need for it to be an optional error, because its only use is as an escape precondition. It should go as a ternary operator inside the for loop that checks for cities weather.
    
    private var outerError:CurrentWeatherError?
    
    required init(webService:WeatherWebServiceProtocol, viewDelegate:CurrentWeatherViewDelegateProtocol, selectionManager:CitySelectionManagerProtocol) {
        self.webService = webService
        self.viewDelegate = viewDelegate
        self.selectionManager = selectionManager
    }
    

    func fetchNumberOfStoredCities() -> Int? {
        selectionManager.fetchCitiesInStudy()?.count
    }
    
    func fetchWeatherForSeletedCities() {
        
        guard let cities = selectionManager.fetchCitiesInStudy() else {
            viewDelegate.didReceiveFailure(currentWeatherError: CurrentWeatherError.ErrorFetchingFromCoreData(description: "Could not fetch objecs from the core data store."))
            return
        }
        
        var resp = [CurrentWeatherResponse]()
        
        for city in cities {
            if outerError != nil {
                return
            }
            webService.fetchCurrentWeather(forCityId: "\(city.id)") { (result) in
                switch result {
                case .success(let response):
                    resp.append(response)
                    self.viewDelegate.didReceiveSuccessfullResponse(currentWeatherObjects: resp)
                case .failure(let error):
                    self.outerError = error
                    self.viewDelegate.didReceiveFailure(currentWeatherError: error)
                }
            }
        }
    }
}


// TODO: = Move this Cities in study to its own file to show it is an extension of cities in study.

extension CitiesInStudy {
    
    var cities:Set<City> {
        get { (cities_ as? Set<City>) ?? [] }
        set { cities_ = (newValue as NSSet) }
    }
    
}
