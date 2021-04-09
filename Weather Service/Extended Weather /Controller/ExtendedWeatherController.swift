//
//  ExtendedWeatherController.swift
//  Weather Service
//
//  Created by Carlos Caraccia on 4/8/21.
//

import UIKit


class ExtendedWeatherController:UIViewController {
    
    var presenter:WeatherDetailsPresenter?
    var currentWeather:CurrentWeatherResponse?
    var extendedWeatherDetails:ExtendedWeatherResponse? { didSet { collectionView.reloadData() } }
    
    lazy var cityTempLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next Demi Bold", size: 17)
        label.numberOfLines = 2
        return label
    }()

    lazy var descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 15)
        return label
    }()

    lazy var maxMinLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 15)
        return label
    }()

    lazy var pressureLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 15)
        return label
    }()

    lazy var humidityLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 15)
        return label
    }()
    
    lazy var currentWeatherIconImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var labelsContainerView:UIView = {
        
        let view = UIView()
        view.addSubview(cityTempLabel)
        cityTempLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 8)
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: cityTempLabel.bottomAnchor, left: view.leftAnchor,paddingTop: 8, paddingLeft: 8)
        view.addSubview(maxMinLabel)
        maxMinLabel.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 8)
        view.addSubview(pressureLabel)
        pressureLabel.anchor(top: maxMinLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 8)
        view.addSubview(humidityLabel)
        humidityLabel.anchor(top: pressureLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 8)
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        return view
    }()
    
    lazy var mainStackView:UIStackView = {
        let views = [labelsContainerView, currentWeatherIconImageView]
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .background
        
        view.addSubview(labelsContainerView)
        labelsContainerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12, height: 160)
        labelsContainerView.backgroundColor = .white
        
        view.addSubview(currentWeatherIconImageView)
        currentWeatherIconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: labelsContainerView.rightAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 12, paddingRight: 12)
        
        configureTopView()
        
        view.addSubview(collectionView)
        collectionView.anchor(top: labelsContainerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 4, paddingRight: 4, height: 200)
        
        
        collectionView.register(ExtendedWeatherCell.self, forCellWithReuseIdentifier: "extendedWeatherIdentifier")
        collectionView.backgroundColor = .background
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let cityId = currentWeather?.id else { return }
        
        if let presenter = presenter {
            presenter.fetchDetailedWeather(forCityId: "\(cityId)")
        } else {
            let webservice = CurrentWeatherWebService()
            let presenter = WeatherDetailsPresenter(webservice: webservice, viewDelegate: self)
            presenter.fetchDetailedWeather(forCityId: "\(cityId)")
        }

    }
    
    
    private func configureTopView() {
        // configure icon
        guard let currentWeather = currentWeather else { return }
        let iconString = currentWeather.weather?.first?.icon ?? ""
        let imageStr = "http://openweathermap.org/img/wn/" + iconString + "@2x.png"
        let imageUrl = URL(string: imageStr)
        currentWeatherIconImageView.sd_setImage(with: imageUrl, completed: nil)
        cityTempLabel.text = "\(currentWeather.name ?? ""), \(currentWeather.sys?.country ?? "") \(currentWeather.main?.temp ?? 0.00)ºC"
        descriptionLabel.text = "desc: \(currentWeather.weather?.first?.description ?? "")"
        maxMinLabel.text = "max: \(currentWeather.main?.temp_max ?? 0.00)ºC - min:\(currentWeather.main?.temp_min ?? 0.00)ºC"
        pressureLabel.text = "Presion: \(currentWeather.main?.pressure ?? 0) MPA"
        humidityLabel.text = "Humedad: \(currentWeather.main?.humidity ?? 0) %"
    }
}

// MARK:- Protocols conformance

extension ExtendedWeatherController:WeatherDetailsViewDelegateProtocol {
    func didReceiveSuccess(forecast: ExtendedWeatherResponse) {
        DispatchQueue.main.async {
            self.extendedWeatherDetails = forecast
        }
    }
    
    func didReceiveFailure(error: CurrentWeatherError) {
        // TODO: - Write code to handle the error with an alert controller.
    }
    
    
}

// MARK:- UICollectionview datasource


extension ExtendedWeatherController:UICollectionViewDataSource {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        extendedWeatherDetails?.list?.count ?? 0
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "extendedWeatherIdentifier", for: indexPath) as! ExtendedWeatherCell
        guard let extendedWeather = extendedWeatherDetails else { return UICollectionViewCell() }
        cell.weather = extendedWeather.list![indexPath.row]
        return cell
    }
    

}


extension ExtendedWeatherController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 160, height: 160)
    }
}
