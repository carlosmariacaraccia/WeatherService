//
//  CurrentWeatherViewCellV3.swift
//  Weather Service
//
//  Created by Carlos Caraccia on 4/27/21.
//

import UIKit
import ShimmerSwift

class CurrentWeatherViewCellV3:UICollectionViewCell {
    
    var cityWeather:CurrentWeatherResponse? {
        didSet {
            guard let cityWeather = cityWeather else { return }
            
            cityShimmerView.isHidden = true
            descriptionShimmerView.isHidden = true
            iconShimmerView.isHidden = true

            loadString(cityWeather: cityWeather)

            cityTempLabel.isHidden = false
            descpritionLabel.isHidden = false
            iconImageView.isHidden = false
        }
    }
    
    private func loadString(cityWeather:CurrentWeatherResponse) {
        let name = cityWeather.name?.uppercased() ?? "No name in city weather"
        let temp = cityWeather.main?.temp ?? 0.00
        let country = cityWeather.sys?.country ?? ""
        let description = cityWeather.weather?.first?.description ?? ""
//      let maxTemp = cityWeather.main?.temp_max ?? 0.00
//      let minTemp = cityWeather.main?.temp_min ?? 0.00
        cityTempLabel.text = name + ", \(country)" + ", \(temp)ºC"
        descpritionLabel.text = description
      let im = cityWeather.weather?.first?.icon ?? ""
      let imageStr = "http://openweathermap.org/img/wn/" + im + "@2x.png"
      let imageUrl = URL(string: imageStr)
      iconImageView.sd_setImage(with: imageUrl, completed: nil)
    }
    
    // MARK: - Main city stack view
    private lazy var cityShimmerView:ShimmeringView = {
        let shimmerView = ShimmeringView()
        let view = UIView()
        view.backgroundColor = .lightGray
        shimmerView.contentView = view
        shimmerView.isShimmering = true
        return shimmerView
    }()
    
    private lazy var cityTempLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next Bold", size: 18)
        label.textColor = UIColor.black.withAlphaComponent(0.7)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private lazy var cityStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cityShimmerView, cityTempLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Description label stack view
    
    private lazy var descriptionShimmerView:ShimmeringView = {
        let shimmerView = ShimmeringView()
        let view = UIView()
        view.backgroundColor = .lightGray
        shimmerView.contentView = view
        shimmerView.isShimmering = true
        return shimmerView
    }()
    
    private lazy var descpritionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 14)
        label.textColor = UIColor.black.withAlphaComponent(0.45)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private lazy var descriptionStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [descriptionShimmerView, descpritionLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var leftStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cityStackView, descriptionStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        stackView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        return stackView
    }()
    
    // MARK: - Description Icon image
    
    private lazy var iconShimmerView:ShimmeringView = {
        let shimmerView = ShimmeringView()
        let view = UIView()
        view.backgroundColor = .lightGray
        shimmerView.contentView = view
        shimmerView.isShimmering = true
        shimmerView.setDimensions(width: 90, height: 90)
        return shimmerView
    }()
    
    lazy var iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 90, height: 90)
        imageView.isHidden = true
        return imageView
    }()

    private lazy var iconStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconShimmerView, iconImageView])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var horizontalStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftStackView, iconStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(horizontalStackView)
        
        backgroundColor = .white
        
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}
