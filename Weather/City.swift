//
//  City.swift
//  Weather
//
//  Created by Александра Леонова on 10.04.2024.
//

import Foundation

struct City: Codable, Equatable {
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey{
        case name = "city"
        case country = "country"
        case latitude = "lat"
        case longitude = "lng"
    }
    
    func save() {
        var cities = City.savedCities
        if cities.contains(self) {
            return
        }
        cities.append(self)
        save(cities)
    }
    
    func delete() {
        var cities = City.savedCities
        cities.removeAll { city in
            city == self
        }
        save(cities)
    }
    
    private static let url = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appending(path: "cities").appendingPathExtension("plist")
        return archiveURL
    }()
    
    private func save(_ cities: [City]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedCites = try? propertyListEncoder.encode(cities)
        
        try? encodedCites?.write(to: City.url)
        print("saved \(cities) to \(City.url)")
    }
    
    static var savedCities: [City] {
        let propertyListDecoder = PropertyListDecoder()
        guard 
            let retrievedCitiesData = try? Data(contentsOf: City.url),
            let savedCities = try? propertyListDecoder.decode([City].self, from: retrievedCitiesData)
        else {
            return []
        }
        print("loaded \(savedCities) from \(City.url)")
        return savedCities
    }
    
    static let allCities = {
        let url = Bundle.main.url(forResource: "city_interactive", withExtension: "json")!
        print(url)
        let data = try! Data(contentsOf: url)
        let cities = try! JSONDecoder().decode([City].self, from: data)
        return cities
    }()
    
    var flag: String? {
        switch country {
        case "Japan":
            return "🇯🇵"
        case "United States":
            return "🇺🇸"
        case "India":
            return "🇮🇳"
        case "Indonesia":
            return "🇮🇩"
        case "China":
            return "🇨🇳"
        case "Philippines":
            return "🇵🇭"
        case "Brazil":
            return "🇧🇷"
        case "Korea, South":
            return "🇰🇷"
        case "Mexico":
            return "🇲🇽"
        case "Egypt":
            return "🇪🇬"
        case "Russia":
            return "🇷🇺"
        case "France":
            return "🇫🇷"
        case "Canada":
            return "🇨🇦"
        case "Germany":
            return "🇩🇪"
        case "Spain":
            return "🇪🇸"
        case "Italy":
            return "🇮🇹"
        case "Hong Kong":
            return "🇭🇰"
        case "Australia":
            return "🇦🇺"
        case "Singapore":
            return "🇸🇬"
        case "Macau":
            return "🇲🇴"
        default:
            return nil
        }
    }
}


