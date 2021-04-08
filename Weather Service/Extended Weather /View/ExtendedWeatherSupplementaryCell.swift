//
//  ExtendedWeatherSupplementaryCell.swift
//  Weather Service
//
//  Created by Carlos Caraccia on 4/8/21.
//

import UIKit

class ExtendedWeatherSupplementaryCell:UICollectionReusableView {
    
    var currentWeather:CurrentWeatherResponse? {
        didSet {
            
            configureLayout()
        }
    }
    
    private func configureLayout() {
        // configure icon
        guard let currentWeather = currentWeather else { return }
        let iconString = currentWeather.weather?.first?.icon ?? ""
        let imageStr = "http://openweathermap.org/img/wn/" + iconString + "@2x.png"
        let imageUrl = URL(string: imageStr)
        currentWeatherIconImageView.sd_setImage(with: imageUrl, completed: nil)
        cityTempLabel.text = "\(currentWeather.name ?? ""), \(currentWeather.main?.temp ?? 0.00)ºC"
        descriptionLabel.text = "\(currentWeather.weather?.first?.description ?? "")"
        maxMinLabel.text = "max: \(currentWeather.main?.temp_max ?? 0.00)ºC - min:\(currentWeather.main?.temp_min ?? 0.00)ºC"
        pressureLabel.text = "presion: \(currentWeather.main?.pressure ?? 0) MPA"
        humidityLabel.text = "humedad: \(currentWeather.main?.humidity ?? 0) %"
    }
    
    lazy var cityTempLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next Demi Bold", size: 15)
        label.numberOfLines = 0
        return label
    }()

    lazy var descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 15)

        label.numberOfLines = 0
        return label
    }()

    lazy var maxMinLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 15)

        label.numberOfLines = 0
        return label
    }()

    lazy var pressureLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 15)

        label.numberOfLines = 0
        return label
    }()

    lazy var humidityLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 15)

        label.numberOfLines = 0
        return label
    }()
    
    lazy var currentWeatherIconImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 150, height: 150)
        iv.layer.cornerRadius = 15
        return iv
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        // for simplicity we will add a stack view
        let views = [cityTempLabel, descriptionLabel, maxMinLabel, pressureLabel, humidityLabel]
        let labelsStackView = UIStackView(arrangedSubviews: views)
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .leading
        labelsStackView.spacing = 2
        labelsStackView.distribution = .equalCentering
        
        let mainStackView = UIStackView(arrangedSubviews: [labelsStackView, currentWeatherIconImageView])
        mainStackView.axis = .horizontal
        
        addSubview(mainStackView)
        mainStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 24, paddingLeft: 12, paddingBottom: 12, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

