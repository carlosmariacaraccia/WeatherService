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
        return button
    }()

    
    // MARK:- Lifecycle

    
    override func viewDidLoad() {
        collectionView.backgroundColor = .green
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
    

}


// MARK:- UICollectionViewDataSource


extension CurrentWeatherController {
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentWeathers?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .blue
        } else {
            cell.backgroundColor = .red
        }
        return cell
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
        
    }
    
    
}



