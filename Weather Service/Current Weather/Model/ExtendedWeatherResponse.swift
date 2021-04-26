//
//  ExtendedWeatherResponse.swift
//  Weather Service
//
//  Created by Carlos Caraccia on 4/6/21.
//


// MARK: - ExtendedWeatherCall
struct ExtendedWeatherResponse:Decodable {
    let cod: String?
    let message, cnt: Int?
    let list: [List]?
    let city: CityResopnse?
}

// MARK: - City
struct CityResopnse:Decodable {
    let id: Int?
    let name: String?
    let coord: Coordinates?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

// MARK: - Coord
struct Coordinates: Decodable {
    let lat, lon: Double?
}

// MARK: - List
struct List:Decodable  {
    let dt: Int?
    let main: MainClass?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let sys: ForecastSys?
    let dt_txt: String?
    let rain: Rain?
}

// MARK: - Forecast sys
struct ForecastSys:Decodable {
   let pod:String?
}

// MARK: - MainClass
struct MainClass:Decodable  {
    let temp, feels_like, temp_min, temp_max: Double?
    let pressure, sea_level, grnd_level, humidity: Int?
    let temp_kf: Double?
}

// MARK: - Rain
struct Rain:Decodable  {
    let the3H: Double?
}


