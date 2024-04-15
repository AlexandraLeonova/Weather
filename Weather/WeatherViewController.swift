//
//  WeatherViewController.swift
//  Weather
//
//  Created by Александра Леонова on 07.04.2024.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet var favButton: UIBarButtonItem!
    var city: City? {
        didSet {
            guard let city = city else { return }
            favButton.isHidden = false
            
            if City.savedCities.contains(city) {
                favButton.image = UIImage(systemName: "heart.fill")
            } else {
                favButton.image = UIImage(systemName: "heart")
            }
            
            didTapGetWeatherButton()
            
            if let flag = city.flag {
                weatherLabel.text = "Weather in \n\(city.name) \(flag)"
            } else {
                weatherLabel.text = "Weather in \n\(city.name)"
            }
        }
    }
    
    let activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var outputData: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var getWeatherButton: UIButton!
    @IBAction func addToFavourites(_ sender : UIBarButtonItem) {
        guard let city else { return }
        
        if City.savedCities.contains(city) {
            city.delete()
            favButton.image = UIImage(systemName: "heart")
        } else {
            city.save()
            favButton.image = UIImage(systemName: "heart.fill")
        }
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        favButton.isHidden = true
        weatherLabel.text = "super⭐️weather"
        getWeatherButton.addTarget(self, action: #selector(didTapGetWeatherButton), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }
        
    @objc func didTapGetWeatherButton() {
        
        guard let unwrappedCity = city else {
            tabBarController?.selectedIndex = 1
            return
        }
        
        updateUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(unwrappedCity.latitude)&longitude=\(unwrappedCity.longitude)&current=temperature_2m,precipitation"
            let url = URL(string: urlString)!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data, let weather = try? JSONDecoder().decode(WeatherData.self, from: data) {
                    DispatchQueue.main.async {
                        self.updateUI(for: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func updateUI(for weather: WeatherData? = nil) {
        if let weather {
            activityIndicator.stopAnimating()
            outputData.textColor = .init(red: 0.222, green: 0.28383, blue: 0.45, alpha: 0.9)
            outputData.font = UIFont.boldSystemFont(ofSize: 25)
            outputData.text = "Temperature = \(weather.current.temperature2M)°C\n\n\nPrecipitation = \(weather.current.precipitation)"
            getWeatherButton.isEnabled = true
        } else {
            activityIndicator.startAnimating()
            outputData.text = "waiting for the forecast"
            outputData.textColor = .systemGray2
            outputData.font = UIFont.systemFont(ofSize: 16)
            getWeatherButton.isEnabled = false
        }
       
    }
}

