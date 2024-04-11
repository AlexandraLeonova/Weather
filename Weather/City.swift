//
//  City.swift
//  Weather
//
//  Created by Александра Леонова on 10.04.2024.
//

import Foundation

struct City: Decodable {
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
    
    static let allCities = {
        let url = Bundle.main.url(forResource: "city_interactive", withExtension: "json")!
       print(url)
        let data = try! Data(contentsOf: url)
        let cities = try! JSONDecoder().decode([City].self, from: data)
        return cities
    }()
    /*city": "Jakarta",
    "city_ascii": "Jakarta",
    "lat": -6.175,
    "lng": 106.8275,
    "country": "Indonesia",
    "iso2": "ID",
    "iso3": "IDN",
    "admin_name": "Jakarta",
    "capital": "primary",
    "population": 33756000,
    "id": 1360771077
*/
}


