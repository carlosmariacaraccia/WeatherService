//
//  CurrrentWeatherCell.swift
//  Weather Service
//
//  Created by Carlos Caraccia on 4/5/21.
//

import UIKit
import SDWebImage

class CurrentWeatherCell:UICollectionViewCell {
    
    var cityWeather:CurrentWeatherResponse? {
        didSet {
            let name = cityWeather?.name ?? ""
            let temp = cityWeather?.main?.temp ?? 0.00
            let description = cityWeather?.weather?.first?.weatherDescription ?? ""
            cityLabel.text = name + ", \(temp)ºC \n \(description)"
            let im = cityWeather?.weather?.first?.icon ?? ""
            let imageStr = "http://openweathermap.org/img/wn/" + im + "@2x.png"
            let imageUrl = URL(string: imageStr)
            weatherIcon.sd_setImage(with: imageUrl, completed: nil)
        }
    }
    
    lazy var cityLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 25)
        label.text = "Clarin Miente"
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var weatherIcon:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 90, height: 90)
        iv.layer.cornerRadius = 10
        return iv
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cityLabel)
        cityLabel.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        cityLabel.text = "City"
        
        
        addSubview(weatherIcon)
        weatherIcon.anchor(top: topAnchor, left: cityLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8)
        let placeHolder = #imageLiteral(resourceName: "weather")
        weatherIcon.image = placeHolder
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
