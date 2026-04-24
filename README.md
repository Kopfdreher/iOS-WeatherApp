# 🌤️ iOS Weather App

[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg?style=flat&logo=swift)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg?style=flat&logo=apple)](https://developer.apple.com/ios/)

A native iOS weather application built with Swift. This project focuses on modern mobile development fundamentals, including asynchronous networking, JSON parsing, and reactive UI updates.



## 🚀 Features

- **Real-time Weather:** Fetches current weather data based on user location or city search.
- **REST API Integration:** Seamlessly communicates with weather services using URLSession.
- **Dynamic UI:** Clean and intuitive interface that adapts to current weather conditions.
- **Location Services:** Uses CoreLocation to automatically detect the user's current city.
- **Responsive Layout:** Designed to look great across all modern iPhone screen sizes.

## 🛠 Tech Stack & Tools

- **Language:** Swift
- **UI Framework:** UIKit / SwiftUI *(Choose the one you used)*
- **Networking:** URLSession & REST APIs
- **Data Parsing:** Codable protocol for JSON mapping
- **Architecture:** MVVM (Model-View-ViewModel)
- **Version Control:** Git & GitHub



## 🏗 Key Learnings

Building this app helped me master several core iOS development concepts:
1.  **Concurrency:** Using `async/await` (or Closures) to handle network calls without freezing the UI.
2.  **Error Handling:** Implementing robust error handling for network failures or invalid API responses.
3.  **API Keys:** Managing sensitive information using Plist files or environment variables.
4.  **Auto Layout:** Mastering constraints to ensure a pixel-perfect design.

## 📸 Screenshots

| Home Screen | Search View | Settings |
| :---: | :---: | :---: |
| *[Add Screenshot]* | *[Add Screenshot]* | *[Add Screenshot]* |

## 🏁 Getting Started

To run this project locally, follow these steps:

1. **Clone the repository:**

   ```bash
   
   git clone https://github.com/Kopfdreher/iOS-WeatherApp.git
   ```
3. **Open in Xcode:**
   Navigate to the project folder and open `WeatherApp.xcodeproj`.
4. **Get an API Key:**
   - Sign up at [OpenWeatherMap](https://openweathermap.org/api) (or whichever API you used).
   - Insert your API key in the designated constant file (e.g., `WeatherManager.swift`).
5. **Build and Run:**
   Select your preferred simulator and hit `Cmd + R`.

*Developed by [Sergej Gavrilov](https://github.com/Kopfdreher) as part of my 42 Berlin Journey.*
