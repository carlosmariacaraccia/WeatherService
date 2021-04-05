//
//  SelectCityViewDelegateProtocol.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 4/1/21.
//

import Foundation


protocol SelectCityViewDelegateProtocol:AnyObject {
    
    func didRecieveCities(cities:[City])
    
    // TODO: - Add a core data error to the Error model of the project, when done, pass it inside this delegate method as custom error to create an alert controller on the view and show the errors.
    func didReceiveError(error:NSError)
    
}
