//
//  CurrentWeatherCellV2.swift
//  Weather Service
//
//  Created by Carlos Caraccia on 4/9/21.
//

import UIKit
import MapKit


protocol CurrentWeatherCellProtocol:class {
    func didTapExpanse(weather:CurrentWeatherResponse)
}

class CurrentWeatherCellV2Presenter:NSObject {
    
    var weather:CurrentWeatherResponse
    var expanded:Bool
    
    init?(weather:CurrentWeatherResponse?, expanded:Bool = false) {
        if let weather = weather {
            self.weather = weather
            self.expanded = expanded
        } else {
            return nil
        }
    }
    
    var cityTemp:NSAttributedString? {
        let name = weather.name?.uppercased() ?? ""
        let temp = weather.main?.temp ?? 0.00
        let country = weather.sys?.country ?? ""
        let attr:[NSAttributedString.Key:AnyHashable] = [.font:UIFont(name: "Avenir Next Bold", size: 18)!, .foregroundColor:UIColor.black.withAlphaComponent(0.6)]
        let string = name + ", \(country)" + ", \(temp)ºC"
        return  NSAttributedString(string: string, attributes: attr)
    }
    
    var climateDescription:NSAttributedString? {
        let description = weather.weather?.first?.description ?? ""
        let attr:[NSAttributedString.Key:AnyHashable] = [.font:UIFont(name: "Avenir Next Demi Bold", size: 16)!, .foregroundColor:UIColor.black.withAlphaComponent(0.45)]
        return  NSAttributedString(string: description, attributes: attr)
    }
    
    var maxTem:NSAttributedString? {
        let maxTemp = weather.main?.temp_max ?? 0.00
        let attr:[NSAttributedString.Key:AnyHashable] = [.font:UIFont(name: "Avenir Next", size: 14)!, .foregroundColor:UIColor.black.withAlphaComponent(0.45)]
        return NSAttributedString(string: "\(maxTemp)", attributes: attr)
    }
    
    var minTemp:NSAttributedString? {
        let minTemp = weather.main?.temp_min ?? 0.00
        let attr:[NSAttributedString.Key:AnyHashable] = [.font:UIFont(name: "Avenir Next", size: 14)!, .foregroundColor:UIColor.black.withAlphaComponent(0.45)]
        return NSAttributedString(string: "\(minTemp)" , attributes: attr)
    }
    
    var iconUrl:URL? {
        guard let im = weather.weather?.first?.icon else { return nil }
        let imageStr = "http://openweathermap.org/img/wn/" + im + "@2x.png"
        return URL(string: imageStr)
    }
    
    var cellHeight:CGFloat? {
        expanded ? 450 : 150.0
    }
        
}


class CurrentWeatherCellV2:UICollectionViewCell {
    
    var currentWeather:CurrentWeatherResponse? {
        didSet {
            guard let weather = currentWeather else { return }
            loadString(cityWeather: weather)
        }
    }
    
    weak var delegate:CurrentWeatherCellProtocol?

    
    private func loadString(cityWeather:CurrentWeatherResponse) {
        let name = cityWeather.name?.uppercased() ?? "No name in city weather"
        let temp = cityWeather.main?.temp ?? 0.00
        let country = cityWeather.sys?.country ?? ""
        let description = cityWeather.weather?.first?.description ?? ""
        let maxTemp = cityWeather.main?.temp_max ?? 0.00
        let minTemp = cityWeather.main?.temp_min ?? 0.00
        maxTempLabel.text = "temp max: \(maxTemp)ºC"
        minTempLabel.text = "temp min: \(minTemp)ºC"
        cityTempLabel.text = name + ", \(country)" + ", \(temp)ºC"
        weatherDescriptionLabel.text = description
        let im = cityWeather.weather?.first?.icon ?? ""
        let imageStr = "http://openweathermap.org/img/wn/" + im + "@2x.png"
        let imageUrl = URL(string: imageStr)
        iconImageView.sd_setImage(with: imageUrl, completed: nil)
    }
    
     func setLocation() {
        guard let lat = currentWeather?.coord?.lat else { return }
        guard let lon = currentWeather?.coord?.lon else { return }
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    lazy var cityTempLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var weatherDescriptionLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var maxTempLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var minTempLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 90, height: 90)
        return imageView
    }()
    
    lazy var upperLabelsStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cityTempLabel, weatherDescriptionLabel, maxTempLabel, minTempLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var mainStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [upperLabelsStackView, rightStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .top
        return stackView
    }()
    
    lazy var rightStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, addDetailsButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .trailing
        return stackView
    }()
    
    lazy var addDetailsButton:UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 5
        button.setDimensions(width: 160, height: 20)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 14)
        button.backgroundColor = .clear
        button.titleLabel?.textColor = UIColor.systemBlue
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.addTarget(self, action: #selector(handleAddDetailsPush), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAddDetailsPush() {
        guard let weather = currentWeather else { return }
        delegate?.didTapExpanse(weather: weather)
    }
    
    lazy var mapStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainStackView, mapView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing  = 12
        return stackView
    }()
    
    
    lazy var mapView:MKMapView = {
        let mapView = MKMapView()
        mapView.setDimensions(width: 100, height: 200)
        mapView.isHidden = true
        mapView.layer.cornerRadius = 15
        return mapView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        backgroundColor = .white
        
        addSubview(mapStackView)
        mapStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
