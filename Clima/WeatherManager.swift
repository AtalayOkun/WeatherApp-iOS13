//
//  WeatherManager.swift
//  Clima
//
//  Created by Atalay Okun on 13.10.2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?

    private func getAPIKey() -> String {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let apiKey = dict["WEATHER_API_KEY"] as? String {
            return apiKey
        } else {
            fatalError("❌ WEATHER_API_KEY not found in Secrets.plist")
        }
    }

    func fetchWeather(cityName: String) {
        let apiKey = getAPIKey()
        let urlString = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let apiKey = getAPIKey()
        let urlString = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.delegate?.didFailWithError(error: error)
                    return
                }
                
                guard let safeData = data else {
                    let customError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from server."])
                    self.delegate?.didFailWithError(error: customError)
                    return
                }
                
                if let weather = self.parseJSON(safeData) {
                    self.delegate?.didUpdateWeather(self, weather: weather)
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            let customError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "City not found, please try again."])
            delegate?.didFailWithError(error: customError)
            return nil
        }
    }
}


