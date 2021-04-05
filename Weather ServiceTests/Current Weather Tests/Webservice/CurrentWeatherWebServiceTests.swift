//
//  CurrentWeatherWebServiceTests.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 3/29/21.
//

import XCTest
@testable import Weather_Service

class CurrentWeatherWebServiceTests: XCTestCase {
    
    var configuration:URLSessionConfiguration!
    var session:URLSession!
    

    override func setUpWithError() throws {
        configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockUrlProtocol.self]
        session = URLSession(configuration: configuration)
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCurrentWeatherWebService_WhenGivenASuccessfullResponse_ReturnsSuccess() {
        let cityId = "1950702"
        let jsonString = "{\"cod\":200}"
        MockUrlProtocol.stubResponseData = jsonString.data(using: .utf8)
        let sut = CurrentWeatherWebService(urlSession: session)
        let myExpectation = expectation(description: "Current weather webservice expectation.")
        sut.fetchCurrentWeather(forCityId:cityId) { result in
            
            switch result {
            case .failure(let error):
                print(error)
                XCTFail("The request returned a failure result when it should have returned a success")
            case .success(let response):
                XCTAssertEqual(response.cod, 200, "The response cod property should be equal to 200, but it was not.")
                myExpectation.fulfill()
            }
        }
        
        wait(for: [myExpectation], timeout: 3)
    }
    
    func testCurrentWeatherWebService_WhenReceivedADifferentModel_ShouldReturnAFailure() {
        
        let cityId = "1950702"
        let jsonString = "{\"cod\":\"200\"}"
        MockUrlProtocol.stubResponseData = jsonString.data(using: .utf8)
        let sut = CurrentWeatherWebService(urlSession: session)
        let myExpectation = expectation(description: "Current weather webservice expectation.")
        sut.fetchCurrentWeather(forCityId: cityId) { result in
            
            switch result {
            case .failure(let error):
                XCTAssertTrue(error.errorDescription != nil, "The Current weather webservice did not returned an error when it was supposed to." )
                myExpectation.fulfill()
            case .success:
                XCTFail("The current weather webservice called the success method when it should call the failure method.")
            }
        }
        
        wait(for: [myExpectation], timeout: 3)
    }
    
    func testCurrentWeatherWebService_WhenAnUnsuccessfullResponseIsReturned_ShouldReturnAFailure() {
        
        let cityId = "xxxxxx"
        let returningError = CurrentWeatherError.ErrorInResponse(description: "There was a problem in the http response.")
        let sut = CurrentWeatherWebService(urlSession: session)
        let myExpectation = expectation(description: "Current weather webservice expectation.")
        sut.fetchCurrentWeather(forCityId: cityId) { result in
    
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, returningError, "The Current weather webservice did not returned the desired error when it was supposed to." )
                myExpectation.fulfill()
            case .success:
                XCTFail("The current weather webservice called the success method when it should call the failure method.")
            }
        }
        wait(for: [myExpectation], timeout: 3)

    }
}

