//
//  MocksWeatherDetailsViewDelegate.swift
//  Weather ServiceTests
//
//  Created by Carlos Caraccia on 4/7/21.
//

import Foundation
import XCTest

@testable import Weather_Service

class MockWeatherDetailsViewDelegate:WeatherDetailsViewDelegateProtocol {
    
    var expectation:XCTestExpectation?
    
    
    func didReceiveSuccess(forecast: ExtendedWeatherResponse) {
        
        expectation?.fulfill()
    }
    
    func didReceiveFailure(error: CurrentWeatherError) {
        
        expectation?.fulfill()
        
    }
    
    
}

