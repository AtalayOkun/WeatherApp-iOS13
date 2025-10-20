# 🌦️ Clima – iOS Weather App

A fully upgraded version of the classic **App Brewery Clima project**, rebuilt with a smoother UI, live location features, splash animation, and improved error handling.

---

## ✨ Features

- 🌍 **Live Location** support via CoreLocation  
- 🔎 **City-based Weather Search** using OpenWeather API  
- 🌀 **Animated Splash Screen** with a looping GIF (custom `UIImage` GIF extension)  
- ⏳ **Loading Spinner** for better UX during data fetching  
- 💬 **Error Handling Alerts** for network and location issues  
- ⚡ **Light Fade-in Animation** on launch  
- 📱 **Keyboard & Input Validation** for cleaner user experience  
- 🌈 **Dynamic Weather Icons** using SF Symbols  
- 🧩 **Modular MVC Structure** (WeatherManager, WeatherModel, WeatherData)

---

## 🛠️ Technologies Used

- **Swift (UIKit)**
- **CoreLocation**
- **URLSession & Codable**
- **OpenWeather API**
- **ImageIO Framework**
- **Storyboard-based UI**

---

## 🚀 Improvements Over the Original

✅ Added **SplashViewController** with animated GIF support  
✅ Added **WeatherManager** error handling (no data, city not found, etc.)  
✅ Added **UIActivityIndicator** with timed fade stop for smoother transitions  
✅ Added **Alert pop-ups** for GPS and network issues  
✅ Added **Tap gesture** to dismiss keyboard  
✅ Refactored **WeatherViewController** with clean delegate handling and structure  
✅ Integrated **custom parsing and safety checks** in WeatherManager  

---

## 🧠 Architecture

- **WeatherManager.swift** → Handles API calls and JSON decoding  
- **WeatherModel.swift** → Processes data and selects appropriate condition icons  
- **WeatherData.swift** → Defines the Codable structure for decoding JSON  
- **WeatherViewController.swift** → Controls the main UI logic  
- **SplashViewController.swift** → Displays animated splash GIF and transitions to the main screen  

---

## 🔑 API Reference

This project uses [OpenWeatherMap API](https://openweathermap.org/api).  
To test it yourself, replace the existing key in `WeatherManager.swift` with your own API key.

```swift
let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=YOUR_API_KEY&units=metric"
