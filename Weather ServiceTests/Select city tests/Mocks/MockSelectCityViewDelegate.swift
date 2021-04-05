//
//  MockSelectCityViewDelegate.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 4/1/21.
//

import Foundation
import XCTest

@testable import Weather_Service

class MockSelectCityViewDelegate: SelectCityViewDelegateProtocol {
    
    var expectation:XCTestExpectation?
    
    func didRecieveCities(cities: [City]) {
        expectation?.fulfill()
    }
    
    func didReceiveError(error: NSError) {
        
    }
    
    
}
