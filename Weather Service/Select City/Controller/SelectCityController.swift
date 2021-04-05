//
//  SelectCityController.swift
//  OpenWeatherApp
//
//  Created by Carlos Caraccia on 4/1/21.
//

import UIKit

class SelectCityController:UITableViewController {
    
    
    // MARK:- Properties
    
    var presenter:SelectCityPresenter?
    
    var cities = [City]() { didSet { tableView.reloadData() } }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        configureUI()
        configureSearchController()
        
        if presenter == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let persistentContainer = appDelegate.persistentContainer
            let storage = SelectionCityStorage(persistentContainer: persistentContainer)
            presenter = SelectCityPresenter(storageService: storage, viewDelegate: self)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }
    
    // MARK:- Helper methods
    
    func configureUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelTap))
        
        if #available(iOS 11.0, *) {
            // For iOS 11 and later, we place the search bar in the navigation bar.
            navigationItem.searchController = searchController
            // We want the search bar visible all the time.
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier, we place the search bar in the table view's header.
            tableView.tableHeaderView = searchController.searchBar
        }

    }
    
    
    func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "City name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    // MARK:- Selectors
    
    @objc func handleCancelTap() {
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK:- CollectionViewDatasource

extension SelectCityController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?

        if let cell1 = tableView.dequeueReusableCell(withIdentifier: "ident") {
            cell = cell1
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ident")
        }
        
        let city = cities[indexPath.row]
        let searchString = searchController.searchBar.text
        
        let cityViewPresenter = SelectCityViewPresenter(city: city, filteredString: searchString)
        cell?.textLabel?.attributedText = cityViewPresenter.attributedString
        
        return cell!
    }
    
}


// MARK:- CollectionViewDelegate

extension SelectCityController {
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        presenter?.addCityToCitiesInStudy(cityToAdd: city)
        searchController.dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
}


// MARK:- SearchResultsUpdating

extension SelectCityController:UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        presenter?.searchForCity(withString: searchText)
    }
    
}

// MARK:- View delegate

extension SelectCityController: SelectCityViewDelegateProtocol {
    
    func didRecieveCities(cities: [City]) {
        self.cities = cities
    }
    
    func didReceiveError(error: NSError) {
        //TODO:- Handle show alert error properly
    }
    
}

