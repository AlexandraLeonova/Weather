//
//  ViewController.swift
//  Weather
//
//  Created by Александра Леонова on 07.04.2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var outputData: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var getWeatherButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherLabel.text = "super⭐️weather"
        getWeatherButton.addTarget(self, action: #selector(didTapGetWeatherButton), for: .touchUpInside)
    }
        
    @objc func didTapGetWeatherButton() {
        outputData.text = "waiting for the forecast"
        outputData.textColor = .init(red: 0.222, green: 0.28383, blue: 0.45, alpha: 0.9)
        outputData.font = UIFont.boldSystemFont(ofSize: 25)
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current=temperature_2m,precipitation"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let data, let weather = try? JSONDecoder().decode(WeatherData.self, from: data) {
                DispatchQueue.main.async {
                    self.outputData.text = "Temperature = \(weather.current.temperature2M)°C\n\n\nPrecipitation = \(weather.current.precipitation)"
                }
            } else {
                print("FAILED")
            }
        }
        task.resume()
    }

}

