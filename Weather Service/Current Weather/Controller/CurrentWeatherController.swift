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
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        collectionView.backgroundColor = .green
        collectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 120, paddingRight: 16, width: 64, height: 64)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    
    /// Batch insert function used only once to map the file cit.list.json dowloaded from open weather to core data. The corrdinates where not mapped into the database because we don't consider it necessary.
    /// - Parameter container: the nspersistent container
    private func batchInsertIntContext(container:NSPersistentContainer) {
        
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        guard let url = Bundle.main.url(forResource: "city.list", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: url, options: .mappedIfSafe) else { return }
        guard let json = try? JSONDecoder().decode([ImportingCityModel].self, from: data) else { return }
        guard let data2 = try? JSONEncoder().encode(json) else { return }
        guard let objects = try? JSONSerialization.jsonObject(with: data2, options: .mutableLeaves) as? [[String:AnyObject]] else { return }
        backgroundContext.performAndWait {
            let batchInsert = NSBatchInsertRequest(entity: City.entity(), objects: objects)
            batchInsert.resultType = .objectIDs
            let result = try? backgroundContext.execute(batchInsert) as? NSBatchInsertResult
            if let objIds = result?.result as? [NSManagedObjectID], !objIds.isEmpty {
                let save = [NSInsertedObjectsKey: objIds]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: save, into: [container.viewContext])
            }
        }
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
        currentWeathers?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CurrentWeatherCell
        cell.cityWeather = currentWeathers![indexPath.row]
        return cell
    }
    
}


// MARK:- UICollectionViewDelegateFlowLayour

extension CurrentWeatherController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - 30, height: 150)
    }
}




// MARK:- CurrentWeatherViewDelegates

extension CurrentWeatherController: CurrentWeatherViewDelegateProtocol {
    
    func didReceiveSuccessfullResponse(currentWeatherObjects: [CurrentWeatherResponse]) {
        DispatchQueue.main.async {
            self.currentWeathers = currentWeatherObjects
        }
    }
    
    func didReceiveFailure(currentWeatherError: CurrentWeatherError) {
        //TODO: - Handle appropiately the error with an alert controller
    }
    
    
}



