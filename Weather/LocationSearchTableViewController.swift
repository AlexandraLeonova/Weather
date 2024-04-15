//
//  LocationSearchTableViewController.swift
//  Weather
//
//  Created by Александра Леонова on 10.04.2024.
//

import UIKit

class LocationSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text,
           !searchString.isEmpty {
            DispatchQueue.global(qos: .userInitiated).async {
                self.filteredCities = City.allCities.filter { city in
                    city.name.localizedCaseInsensitiveContains(searchString) || city.country.localizedCaseInsensitiveContains(searchString)
                }
            }
        } else {
            filteredCities = City.allCities
        }
    }
    
    var filteredCities = City.allCities {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Find city"
//        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.returnKeyType = .done
        searchController.searchBar.searchTextField.enablesReturnKeyAutomatically = true
        searchController.searchBar.searchTextField.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let city = filteredCities[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = city.name
        content.secondaryText = city.country
        
//        searchController.searchBar.searchTextField.resignFirstResponder()
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let navigationController = tabBarController?.viewControllers?.first as? UINavigationController
        let weatherViewController = navigationController?.viewControllers.first as? WeatherViewController
        weatherViewController?.city = filteredCities[indexPath.row]
        tabBarController?.selectedIndex = 0
    }
}

extension LocationSearchTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
