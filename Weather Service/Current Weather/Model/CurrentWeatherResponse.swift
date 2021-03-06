//
//  CurrentWeatherResponse.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 3/29/21.
//

import Foundation


struct CurrentWeatherResponse:Decodable {
    
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
    let coord:Coordinates?
    
}



// MARK: - Clouds
struct Clouds:Decodable {
    let all: Int?
}

// MARK: - Main
struct Main:Decodable {
    let temp, feelsLike, temp_min, temp_max: Double?
    let pressure, humidity: Int?
}

// MARK: - Sys
struct Sys:Decodable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - Weather
struct Weather:Decodable {
    let id: Int?
    let main, description, icon: String?
}

// MARK: - Wind
struct Wind:Decodable {
    let speed: Double?
    let deg: Int?
}
