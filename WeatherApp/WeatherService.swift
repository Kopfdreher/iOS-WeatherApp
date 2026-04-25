//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Sergej Gavrilov on 16.04.26.
//

import SwiftUI
import Combine

struct GeocodingResponse: Decodable, Sendable {
  let results: [Location]?
}

struct Location: Decodable, Identifiable, Sendable {
  let id: Int
  let name: String
  let admin1: String?
  let country: String
  let latitude: Double
  let longitude: Double
}

struct WeatherResponse: Decodable, Sendable {
  let current_weather: CurrentWeather
  let hourly: HourlyData
  let daily: DailyData
}

struct CurrentWeather: Decodable, Sendable {
  let temperature: Double
  let windspeed: Double
  let weathercode: Int
}

struct HourlyData: Decodable, Sendable {
  let time: [String]
  let temperature_2m: [Double]
  let weathercode: [Int]
  let windspeed_10m: [Double]
}

struct DailyData: Decodable, Sendable {
  let time: [String]
  let weathercode: [Int]
  let temperature_2m_max: [Double]
  let temperature_2m_min: [Double]
}

@MainActor
class WeatherService: ObservableObject {
  @Published var suggestions: [Location] = []
  @Published var weatherInfo: WeatherResponse?
  @Published var selectedLocation: Location?
  @Published var errorMessage: String?

  func fetchWeather(for location: Location) {
    self.selectedLocation = location
    self.errorMessage = nil

    let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(location.latitude)&longitude=\(location.longitude)&current_weather=true&hourly=temperature_2m,weathercode,windspeed_10m&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=auto"

    guard let url = URL(string: urlString) else { return }

    Task {
      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        self.weatherInfo = try JSONDecoder().decode(WeatherResponse.self, from: data)
      } catch {
        self.errorMessage = "Could not retrieve weather data. Please check your internet connection and try again."
        print("Weather fetch error: \(error)")
      }
    }
  }

  func weatherIcon(_ code: Int) -> String {
    switch code {
    case 0: return "sun.max.fill"
    case 1...3: return "cloud.sun.fill"
    case 45, 48: return "cloud.fog.fill"
    case 51...55: return "cloud.drizzle.fill"
    case 61...65: return "cloud.rain.fill"
    case 71...75: return "cloud.snow.fill"
    case 80...82: return "cloud.heavyrain.fill"
    case 95...99: return "cloud.bolt.rain.fill"
    default: return "questionmark.circle"
    }
  }

  func weatherDescription(_ code: Int) -> String {
    switch code {
    case 0: return "Clear sky"
    case 1...3: return "Partly cloudy"
    case 45, 48: return "Fog"
    case 51...55: return "Drizzle"
    case 61...65: return "Rain"
    case 71...75: return "Snow"
    case 80...82: return "Rain showers"
    case 95...99: return "Thunderstorm"
    default: return "Unkown"
    }
  }

  func fetchCities(query: String) {
    guard query.count > 2 else {
      self.suggestions = []
      return
    }

    let urlString = "https://geocoding-api.open-meteo.com/v1/search?name=\(query)&count=5&language=en&format=json"
    guard let url = URL(string: urlString) else { return }

    Task {
      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let response = try decoder.decode(GeocodingResponse.self, from: data)

        if response.results == nil || response.results?.isEmpty == true {
          self.errorMessage = "Could not find any city with the name \(query)."
          self.suggestions = []
        } else {
          self.errorMessage = nil
          self.suggestions = response.results ?? []
        }
      } catch {
        self.errorMessage = "Could not find any city."
        self.suggestions = []
        self.weatherInfo = nil
      }
    }
  }
}
