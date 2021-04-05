//
//  MockCurrentWeatherViewDelegate.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 3/30/21.
//

import Foundation
import XCTest
@testable import Weather_Service

class MockCurrentWeatherViewDelegate: CurrentWeatherViewDelegateProtocol{
    
    var myExpectation:XCTestExpectation?
    var failureExpectation:XCTestExpectation?
    var counter = 0
    
    func didReceiveSuccessfullResponse(currentWeatherObjects: [CurrentWeatherResponse]) {
        counter += 1
        if counter == 2 {
            myExpectation?.fulfill()
        }
    }
    
    func didReceiveFailure(currentWeatherError: CurrentWeatherError) {
        failureExpectation?.fulfill()
    }
}
