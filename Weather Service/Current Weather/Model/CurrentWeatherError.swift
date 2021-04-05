//
//  CurrentWeatherError.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 3/29/21.
//

import Foundation


enum CurrentWeatherError:LocalizedError, Equatable {
    
    case ErrorCastingResopnse(description: String)
    case ErrorInResponse(description:String)
    case ErrorCreatingURL(description:String)
    case ErrorFetchingFromCoreData(description:String)
    
    var errorDescription: String? {
        switch self {
        case .ErrorCastingResopnse(let description):
            return description
        case .ErrorInResponse(let description):
            return description
        case .ErrorCreatingURL(let description):
            return description
        case .ErrorFetchingFromCoreData(let description):
            return description
        }
    }
    
}

