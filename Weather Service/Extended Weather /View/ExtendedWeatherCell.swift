//
//  ExtendedWeatherCell.swift
//  Weather Service
//
//  Created by Carlos Caraccia on 4/8/21.
//

import UIKit


class ExtendedWeatherCell:UICollectionViewCell {
    
    var weather:List? { didSet { configureView() } }
    
    private lazy var dateFormat:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd"
        dateFormatter.locale = .current
        return dateFormatter
    }()
    
    private lazy var timeFormat:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()

    
    private func configureView() {
        let seconds = weather?.dt ?? 0
        let date = Date(timeIntervalSince1970: TimeInterval(seconds))
        dateLabel.text = "\(dateFormat.string(from: date))"
        timeLabel.text = "\(timeFormat.string(from: date)) hs"
        maxTempLabel.text = "max: \(weather?.main?.temp_max ?? 0.00)ºC"
        minTempLabel.text = "min: \(weather?.main?.temp_min ?? 0.00)ºC"
        guard let weather = weather else { return }
        let iconString = weather.weather?.first?.icon ?? ""
        let imageStr = "http://openweathermap.org/img/wn/" + iconString + "@2x.png"
        let imageUrl = URL(string: imageStr)
        iconImageView.sd_setImage(with: imageUrl, completed: nil)
    }
    
    private lazy var dateLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 18)
        return label
    }()
    
    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    
    private let maxTempLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 14)
        return label
    }()
    
    private let minTempLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 14)
        return label
    }()

    
    private lazy var iconImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        layer.cornerRadius = 10
        backgroundColor = .white
        
        let views = [dateLabel, timeLabel, iconImageView, maxTempLabel, minTempLabel]
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        addSubview(stackView)
        stackView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
