//
//  WeatherData.swift
//  Clima
//
//  Created by Atakan Tul on 15.10.2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main:Codable {
    let temp: Double
}

struct Weather:Codable {
    let description: String
    let id: Int
}
