//
//  CurrentWeatherViewDelegateProtocol.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 3/30/21.
//

import Foundation


protocol CurrentWeatherViewDelegateProtocol:AnyObject {
    func didReceiveSuccessfullResponse(currentWeatherObjects:[CurrentWeatherResponse])
    func didReceiveFailure(currentWeatherError:CurrentWeatherError)
}
