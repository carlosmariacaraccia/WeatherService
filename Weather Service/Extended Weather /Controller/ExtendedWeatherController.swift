//
//  ExtendedWeatherController.swift
//  Weather Service
//
//  Created by Carlos Caraccia on 4/8/21.
//

import UIKit


class ExtendedWeatherController:UICollectionViewController {
    
    var presenter:WeatherDetailsPresenter?
    var currentWeather:CurrentWeatherResponse?
    var extendedWeatherDetails:ExtendedWeatherResponse?
    
    override func viewDidLoad() {
        collectionView.register(ExtendedWeatherSupplementaryCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerReuseIdentifier")
        collectionView.backgroundColor = .background
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


// MARK:- Header cell

extension ExtendedWeatherController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerReuseIdentifier", for: indexPath) as! ExtendedWeatherSupplementaryCell
        header.currentWeather = currentWeather
        return header
    }
}


extension ExtendedWeatherController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.width, height: 200)
    }
}
