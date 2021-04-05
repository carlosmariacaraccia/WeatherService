//
//  SelectCityViewPresenter.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 4/2/21.
//

import UIKit

struct SelectCityViewPresenter {
    
    private let city:City
    var filteredString:String?
    
    init(city:City, filteredString:String? = nil) {
        self.city = city
        self.filteredString = filteredString
    }
    
    
    var attributedString:NSAttributedString? {
        guard var dsiplayingName = city.name else { return nil }
        if let state = city.state, state != "" {
            dsiplayingName = dsiplayingName + ", \(state)"
        }
        dsiplayingName = dsiplayingName + ", "
        guard let country = city.country else { return nil }
        let displayingAttributes:[NSAttributedString.Key:Any] = [.font:UIFont(name: "Avenir Next", size: 15)!, .foregroundColor: UIColor.black.withAlphaComponent(0.8)]
        let countryAttributes:[NSAttributedString.Key:Any] = [.font:UIFont(name: "Avenir Next", size: 15)!, .foregroundColor:UIColor.black.withAlphaComponent(0.7)]
        let mutableString = NSMutableAttributedString(string: dsiplayingName, attributes: displayingAttributes)
        let attr = NSAttributedString(string: country, attributes: countryAttributes)
        mutableString.append(attr)
        if let filteredString = filteredString?.lowercased(), let stringToSearchIn = mutableString.string.lowercased() as NSString? {
            let shortNameRange = stringToSearchIn.range(of: filteredString, options: .regularExpression, range: NSMakeRange(0, stringToSearchIn.length))
            let cuitRange = stringToSearchIn.range(of: filteredString, options: .regularExpression, range: NSMakeRange(0, stringToSearchIn.length))
            mutableString.addAttribute(.backgroundColor, value: UIColor.red.withAlphaComponent(0.4), range: shortNameRange)
            mutableString.addAttribute(.backgroundColor, value: UIColor.red.withAlphaComponent(0.4), range: cuitRange)
            return mutableString
        } else {
            return mutableString
        }
    }
}
