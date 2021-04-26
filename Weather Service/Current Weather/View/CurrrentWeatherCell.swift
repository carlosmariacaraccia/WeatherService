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
//            guard let cityWeather = cityWeather else { return }
//            removeViews()
//            addLabelsAndIcons()
//            loadString(cityWeather: cityWeather)
        }
    }
    
    // MARK:- Dummy properties to be seen when the view is being loaded

     var loadingIconCityWeatherView:UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.setDimensions(width: 92, height: 92)
        view.layer.cornerRadius = 5
        return view
    }()
    
    lazy var loadingMainCityWeatherView:UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    lazy var loadingDescriptionCityWeatherView:UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var leftContainerView:UIView = {
        let view = UIView()
        
        view.addSubview(loadingMainCityWeatherView)
        loadingMainCityWeatherView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, height: 40)
        
        view.addSubview(loadingDescriptionCityWeatherView)
        loadingDescriptionCityWeatherView.anchor(top: loadingMainCityWeatherView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, height: 20)
        
        return view
    }()
    
    // MARK:- Properties to show after the view has been loaded

    private lazy var cityLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 12)
        label.numberOfLines = 0
        return label
    }()
    
    
    private lazy var weatherIcon:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 92, height: 92)
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    private lazy var loadedLeftContainerView:UIView = {
        let view = UIView()
        
        view.addSubview(cityLabel)
        cityLabel.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, height: 40)
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: cityLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 4, paddingLeft: 12, height: 20)
        
        return view
    }()
        
    
    // MARK:- Helper functions

    private func removeViews() {
        leftContainerView.removeConstraints(leftContainerView.constraints)
        leftContainerView.removeFromSuperview()
        loadingIconCityWeatherView.removeConstraints(loadingIconCityWeatherView.constraints)
        loadingIconCityWeatherView.removeFromSuperview()
    }
    
    private func addLabelsAndIcons() {
        addSubview(loadedLeftContainerView)
        loadedLeftContainerView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 8, height: 30)
        
        addSubview(weatherIcon)
        weatherIcon.anchor(top: topAnchor, left: loadedLeftContainerView.rightAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
    }
    
    
    //TODO: - Rename this load string awfull name for a funtion to something more suitable.
    
    private func loadString(cityWeather:CurrentWeatherResponse) {
        
        let name = cityWeather.name ?? "No name in city weather"
        let temp = cityWeather.main?.temp ?? 0.00
        let description = cityWeather.weather?.first?.description ?? ""
        cityLabel.text = name + ", \(temp)ºC"
        descriptionLabel.text = description
        let im = cityWeather.weather?.first?.icon ?? ""
        let imageStr = "http://openweathermap.org/img/wn/" + im + "@2x.png"
        let imageUrl = URL(string: imageStr)
        weatherIcon.sd_setImage(with: imageUrl, completed: nil)
        
    }

    
    // MARK:- Initialization of the views
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        layer.cornerRadius = 10
        
        addSubview(leftContainerView)
        leftContainerView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 8, height: 30)
        
        addSubview(loadingIconCityWeatherView)
        loadingIconCityWeatherView.anchor(top: topAnchor, left: leftContainerView.rightAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
            
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
