//
//  WeatherDetailsPresenterTests.swift
//  Weather ServiceTests
//
//  Created by Carlos Caraccia on 4/7/21.
//

import XCTest
@testable import Weather_Service

class WeatherDetailsPresenterTests: XCTestCase {
    
    var mockWebService:MockCurrentWeatherWebService!
    var mockViewDelegate:MockWeatherDetailsViewDelegate!
    var sut:WeatherDetailsPresenter!

    override func setUpWithError() throws {
        mockWebService = MockCurrentWeatherWebService()
        mockViewDelegate = MockWeatherDetailsViewDelegate()
        sut = WeatherDetailsPresenter(webservice: mockWebService, viewDelegate: mockViewDelegate)
    }

    override func tearDownWithError() throws {
        mockViewDelegate = nil
        mockWebService = nil
        sut = nil
    }

    func testWeatherDetailsPresenter_WhenFetchDetailedWeatherForCityIdIsCalled_CallsFetchDetailedWeatherOnTheWebService() {
        
        let cityId = "1950702"
        sut.fetchDetailedWeather(forCityId: cityId)
        XCTAssertTrue(mockWebService.isFetchWeatherDetailsCalled, "WeatherDetailsPresenter did not call FetchExtendedWeather() method in the webservice.")
    }
    
    func testWeatherDetailsPresenter_WhenGivenASuccessFulResponse_CallsSuccessInTheViewDelegate() {
        
        let cityId = "1950702"
        let myExpectation = expectation(description: "Calls success on view delegate.")
        mockViewDelegate.expectation = myExpectation
        sut.fetchDetailedWeather(forCityId: cityId)
        wait(for: [myExpectation], timeout: 3)
    }
    
    func testWeatherDetailsPresenter_WhenGivenAFailureRespose_CallsDidReceiveErrorInTheViewDelegate() {
        
        let cityId = "1950702"
        let myExpectation = expectation(description: "Call didReceiveError on the view delegate.")
        let error = CurrentWeatherError.ErrorInResponse(description: "We received and error from the server.")
        mockViewDelegate.expectation = myExpectation
        mockWebService.extendedWeatherError = error
        sut.fetchDetailedWeather(forCityId: cityId)
        wait(for: [myExpectation], timeout: 3)

    }
    
}
