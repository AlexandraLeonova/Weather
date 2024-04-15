//
//  FavLocationsTableViewController.swift
//  Weather
//
//  Created by Александра Леонова on 10.04.2024.
//

import UIKit

class FavLocationsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return City.savedCities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let city = City.savedCities.reversed()[indexPath.row]

        // Configure the cell...
        var content = cell.defaultContentConfiguration()
        
        if let flag = city.flag {
            content.text = city.name + " \(flag)"
        } else {
            content.text = city.name
        }
        content.secondaryText = city.country
    
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigationController = tabBarController?.viewControllers?.first as? UINavigationController
        let weatherViewController = navigationController?.viewControllers.first as? WeatherViewController
        weatherViewController?.city = City.savedCities.reversed()[indexPath.row]
        tabBarController?.selectedIndex = 0
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, _ in
            City.savedCities.reversed()[indexPath.row].delete()
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
