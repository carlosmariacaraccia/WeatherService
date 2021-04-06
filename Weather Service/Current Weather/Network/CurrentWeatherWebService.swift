//
//  CurrentWeatherWebService.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 3/29/21.
//

import Foundation


class CurrentWeatherWebService:CurrentWeatherWebServiceProtocol {
    
    private var urlSession:URLSession
    
     init(urlSession:URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchCurrentWeather(forCityId cityId: String, completionHandler:@escaping(Result<CurrentWeatherResponse,CurrentWeatherError>)->Void) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        let queryItem1 = URLQueryItem(name: "id", value: cityId)
        let queryItem2 = URLQueryItem(name: "lang", value: "es")
        let queryItem3 = URLQueryItem(name: "units", value: "metric")
        let queryItem4 = URLQueryItem(name: "appid", value: "3deb5e13d6f1b909acd03720e9822e54")
        components.queryItems = [queryItem1, queryItem2, queryItem3, queryItem4]
        
        //TODO: - Create a function to take out the url components code out of the request funtion (it has nothid to do with the request so it can go away. Besides I need only one paramenter, so I can make it safe.
        
        guard let url = components.url else {
            completionHandler(.failure(CurrentWeatherError.ErrorCreatingURL(description: "Could not create the url.")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        urlSession.dataTask(with: request) { (data, response, error) in
            if let safeData = data {
                do {
                    let currentWeather = try JSONDecoder().decode(CurrentWeatherResponse.self, from: safeData)
                    completionHandler(Result.success(currentWeather))
                } catch let error {
                    completionHandler(.failure(CurrentWeatherError.ErrorCastingResopnse(description: error.localizedDescription)))
                }
            } else {
                completionHandler(.failure(CurrentWeatherError.ErrorInResponse(description: "There was a problem in the http response.")))
            }
        }.resume()
    }
}
