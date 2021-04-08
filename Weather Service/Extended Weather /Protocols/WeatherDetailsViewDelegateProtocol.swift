//
//  WeatherDetailsViewDelegateProtocol.swift
//  Weather Service
//
//  Created by Carlos Caraccia on 4/7/21.
//

import Foundation


protocol WeatherDetailsViewDelegateProtocol:AnyObject {
    func didReceiveSuccess(forecast:ExtendedWeatherResponse)
    func didReceiveFailure(error:CurrentWeatherError)
}
