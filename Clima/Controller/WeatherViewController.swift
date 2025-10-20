//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!

    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    let spinner = UIActivityIndicatorView(style: .large)
    private var spinnerStartTime: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fade-in başlangıç
        view.alpha = 0.0
        UIView.animate(withDuration: 0.5) { self.view.alpha = 1.0 }

        // Delegeler
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self

        // Klavye kapatma
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        // Spinner ayarları
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        spinner.color = .systemTeal
        view.addSubview(spinner)

        // Konum izni iste
        locationManager.requestWhenInUseAuthorization()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func locationPressed(_ sender: UIButton) {
        startSpinner()
        locationManager.requestLocation()
    }

    private func startSpinner() {
        spinnerStartTime = Date()
        spinner.startAnimating()
    }

    private func stopSpinnerWithMinDuration() {
        let minDuration: TimeInterval = 0.5
        if let start = spinnerStartTime {
            let elapsed = Date().timeIntervalSince(start)
            let delay = max(minDuration - elapsed, 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { self.spinner.stopAnimating() }
        } else {
            spinner.stopAnimating()
        }
    }

    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

//  MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {

    @IBAction func searchPressed(_ sender: UIButton) {
        if let text = searchTextField.text, !text.isEmpty {
            startSpinner()
        }
        searchTextField.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = searchTextField.text, !text.isEmpty {
            startSpinner()
        }
        searchTextField.endEditing(true)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.placeholder = "Type something"
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text?.trimmingCharacters(in: .whitespaces), !city.isEmpty {
            startSpinner()
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//  MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {

    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.stopSpinnerWithMinDuration()
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }

    func didFailWithError(error: any Error) {
        DispatchQueue.main.async {
            self.stopSpinnerWithMinDuration()
            self.showError(message: error.localizedDescription)
        }
        print(error)
    }
}

//  MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {

    // iOS 13 ve altı için
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startSpinner()
            manager.requestLocation()
        case .denied, .restricted:
            showError(message: "Couldn't find your location. Please enable GPS in Settings.")
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            startSpinner()
            weatherManager.fetchWeather(latitude: location.coordinate.latitude,
                                        longitude: location.coordinate.longitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.stopSpinnerWithMinDuration()
            self.showError(message: "Couldn't find your location. Please check GPS settings.")
        }
        print(error)
    }
}
