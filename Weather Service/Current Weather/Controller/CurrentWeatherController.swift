//
//  CurrentWeatherController.swift
//  Weather Service
//
//  Created by Carlos Caraccia on 4/5/21.
//

import UIKit
import CoreData

private let reuseIdentifier = "reuseIdentifier"

class CurrentWeatherController:UICollectionViewController {
    
    
    // MARK:- Properties
    
    
    var currentWeatherPresenter:CurrentWeatherPresenterProtocol?
    var currentWeathers:[CurrentWeatherResponse]?
    
    lazy var actionButton:UIButton = {
        let button = UIButton(type: .system)
        let buttonImage = UIImage(systemName: "plus")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.shadowRadius = 3
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)
        return button
    }()
    
    
    // MARK:- Lifecycle
    
    
    override func viewDidLoad() {
        configureCollectionView()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentWeatherPresenter != nil {
            currentWeatherPresenter?.fetchWeatherForSeletedCities()
        } else {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let cont = appDelegate.persistentContainer
            let webservice = CurrentWeatherWebService()
            let selectionManager = CitySelectionManager(container: cont)
            currentWeatherPresenter = CurrentWeatherPresenter(webService: webservice, viewDelegate: self, selectionManager: selectionManager)
            currentWeatherPresenter?.fetchWeatherForSeletedCities()
        }

    }
        
    // MARK:- Helper functions
    
    
    func configureCollectionView() {
        collectionView.backgroundColor = .background
        collectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 120, paddingRight: 16, width: 64, height: 64)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    // MARK:- Selectors
    
    @objc func handleActionButtonTap() {
        let selectCity = SelectCityController()
        let navCon = UINavigationController(rootViewController: selectCity)
        navCon.modalPresentationStyle = .fullScreen
        present(navCon, animated: true, completion: nil)
    }
    
}


// MARK:- UICollectionViewDataSource


extension CurrentWeatherController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cities = currentWeatherPresenter?.fetchNumberOfStoredCities() ?? 5
        return currentWeathers?.count ?? cities
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CurrentWeatherCell
        if let climateInCities = currentWeathers {
            cell.loadingIconCityWeatherView.stopShimmeringAnimation()
            cell.loadingDescriptionCityWeatherView.stopShimmeringAnimation()
            cell.loadingMainCityWeatherView.stopShimmeringAnimation()
            cell.cityWeather = climateInCities[indexPath.row]
        } else {
            cell.loadingIconCityWeatherView.startShimmeringAnimation()
            cell.loadingDescriptionCityWeatherView.startShimmeringAnimation()
            cell.loadingMainCityWeatherView.startShimmeringAnimation()
        }
        return cell
    }
}


// MARK:- UICollectionViewDelegateFlowLayour

extension CurrentWeatherController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - 30, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
}




// MARK:- CurrentWeatherViewDelegates

extension CurrentWeatherController: CurrentWeatherViewDelegateProtocol {
    
    func didReceiveSuccessfullResponse(currentWeatherObjects: [CurrentWeatherResponse]) {
        let numberOfCitiesStored = currentWeatherPresenter?.fetchNumberOfStoredCities()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if numberOfCitiesStored == currentWeatherObjects.count {
                self.currentWeathers = currentWeatherObjects
                self.collectionView.reloadData()
            }
        }
    }
    
    func didReceiveFailure(currentWeatherError: CurrentWeatherError) {
        //TODO: - Handle appropiately the error with an alert controller
    }
    
    
}



