//
//  CurrentWeatherViewCellV3.swift
//  Weather Service
//
//  Created by Carlos Caraccia on 4/27/21.
//

import UIKit
import ShimmerSwift

class CurrentWeatherViewCellV3:UICollectionViewCell {
    
    // Pan gesture recognizer
    var panGestureRecognizer:UIPanGestureRecognizer!
    
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
        cityTempLabel.text = name + ", \(country)" + ", \(temp)ºC"
        descpritionLabel.text = description
      let im = cityWeather.weather?.first?.icon ?? ""
      let imageStr = "http://openweathermap.org/img/wn/" + im + "@2x.png"
      let imageUrl = URL(string: imageStr)
      iconImageView.sd_setImage(with: imageUrl, completed: nil)
    }
    
    // MARK: - Delete label to insert below the content view
    
    private lazy var deleteLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next Bold", size: 18)
        label.textColor = .white
        label.text = "Delete"
        return label
    }()
    
    private lazy var deleteLabel2:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next Bold", size: 18)
        label.textColor = .white
        label.text = "Delete"
        return label
    }()
    
    
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
        
        self.backgroundColor = .red
        
        self.contentView.addSubview(horizontalStackView)
        self.contentView.backgroundColor = .white
        
        // set the corner radius property
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        // set the constraints
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        // set the delete label below the content view
        self.insertSubview(deleteLabel, belowSubview: contentView)
        self.insertSubview(deleteLabel2, belowSubview: contentView)
        
        // set up the pan gesture recognizer
        setupPanGestureRecognizer()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGestureRecognizer.delegate = self
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    
}


extension CurrentWeatherViewCellV3:UIGestureRecognizerDelegate {
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (panGestureRecognizer.state == UIGestureRecognizer.State.changed) {
            let panPoint = panGestureRecognizer.translation(in: self)
            let width = contentView.frame.width
            let height = contentView.frame.height
            
            contentView.frame = CGRect(x: panPoint.x, y: 0, width: width, height: height)
            deleteLabel.frame = CGRect(x: panPoint.x - deleteLabel.frame.size.width - 6, y: 0, width: 100, height: height)
            deleteLabel2.frame = CGRect(x: panPoint.x + width + deleteLabel2.frame.size.width, y: 0, width: 100, height: height)
            
        }
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizer.State.began {

        } else if pan.state == UIGestureRecognizer.State.changed {
        self.setNeedsLayout()
      } else {
        if abs(pan.velocity(in: self).x) > 500 {
          let collectionView: UICollectionView = self.superview as! UICollectionView
          let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
          collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
        } else {
          UIView.animate(withDuration: 0.2, animations: {
            self.setNeedsLayout()
            self.layoutIfNeeded()
          })
        }
      }
    }
}
