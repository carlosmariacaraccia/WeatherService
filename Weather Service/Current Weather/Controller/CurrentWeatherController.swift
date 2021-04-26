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
    
    var tappedWeathers = [CurrentWeatherResponse]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var currentWeatherPresenter:CurrentWeatherPresenterProtocol?
    var currentWeathers:[CurrentWeatherResponse]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
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
        callPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callPresenter()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    // MARK:- Helper functions
    
    private func callPresenter() {
        if currentWeatherPresenter != nil {
            currentWeatherPresenter?.fetchWeatherForSeletedCities()
        } else {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let cont = appDelegate.persistentContainer
            let webservice = WeatherWebService()
            let selectionManager = CitySelectionManager(container: cont)
            currentWeatherPresenter = CurrentWeatherPresenter(webService: webservice, viewDelegate: self, selectionManager: selectionManager)
            currentWeatherPresenter?.fetchWeatherForSeletedCities()
        }
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .background
        collectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        //collectionView.register(CurrentWeatherCellV2.self, forCellWithReuseIdentifier: reuseIdentifier)
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

        
//        if let climateInCities = currentWeathers {
//            let weather = climateInCities[indexPath.row]
//            cell.delegate = self
//            cell.currentWeather = climateInCities[indexPath.row]
//            if tappedWeathers.contains(where: {$0.id == currentWeathers![indexPath.row].id} ) {
//                UIView.animate(withDuration: 0.5) {
//                    cell.addDetailsButton.setTitle("HIDE DETAILS", for: .normal)
//                    cell.mapView.isHidden = false
//                    cell.setLocation()
//                }
//            } else {
//                cell.addDetailsButton.setTitle("SHOW DETAILS", for: .normal)
//                cell.mapView.isHidden = true
//            }
//        }
        return cell
    }
}

// MARK:- UICollectionViewControllerDelegate

extension CurrentWeatherController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let weathers = currentWeathers else { return }
        let selectedWeather = weathers[indexPath.row]
        let controller = ExtendedWeatherController()
        controller.currentWeather = selectedWeather
        navigationController?.pushViewController(controller, animated: true)        
    }
}



// MARK:- UICollectionViewDelegateFlowLayout

extension CurrentWeatherController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // check if the weather cell was been tapped
        if tappedWeathers.contains(where: {$0.id == currentWeathers![indexPath.row].id} ) {
            return CGSize(width: view.frame.width - 24, height: 450)
        } else {
            return CGSize(width: view.frame.width - 24, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

extension CurrentWeatherController:CurrentWeatherCellProtocol {
    func didTapExpanse(weather: CurrentWeatherResponse) {
        if tappedWeathers.contains(where: { $0.id == weather.id } ) {
            tappedWeathers.removeAll(where: {$0.id == weather.id })
        } else {
            tappedWeathers.append(weather)
        }
    }
    
    
}




// MARK:- CurrentWeatherViewDelegates

extension CurrentWeatherController: CurrentWeatherViewDelegateProtocol {
    
    func didReceiveSuccessfullResponse(currentWeatherObjects: [CurrentWeatherResponse]) {
        let numberOfCitiesStored = currentWeatherPresenter?.fetchNumberOfStoredCities()
        // this is done to make all the cities appear toghether in the collection view.
        DispatchQueue.main.async {
            if numberOfCitiesStored == currentWeatherObjects.count {
                self.currentWeathers = currentWeatherObjects
            }
        }
    }
    
    func didReceiveFailure(currentWeatherError: CurrentWeatherError) {
        //TODO: - Handle appropiately the error with an alert controller
    }
}

