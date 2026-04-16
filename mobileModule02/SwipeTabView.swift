//
//  SwipeTabView.swift
//  mobileModule02
//
//  Created by Sergej Gavrilov on 15.04.26.
//

import SwiftUI
import Combine
import CoreLocation

struct SwipeTabView: View {
  @Binding var selectedTab: Int
  @ObservedObject var locationManager: LocationManager
  @ObservedObject var weatherService: WeatherService

  var body: some View {
    TabView(selection: $selectedTab) {
      CurrentlyView(weatherService: weatherService)
        .tag(0)
      TodayView(weatherService: weatherService)
        .tag(1)
      WeeklyView(weatherService: weatherService)
        .tag(2)
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
}

struct CurrentlyView: View {
  @ObservedObject var weatherService: WeatherService

  var body: some View {
    VStack(spacing: 10) {
      Text("Currently")
        .font(.largeTitle)

      if let loc = weatherService.selectedLocation, let weather = weatherService.weatherInfo {
        Text("\(loc.name)")
        Text("\(loc.admin1 ?? ""), \(loc.country)")
        Text("\(Int(weather.current_weather.temperature))°C")
        Text(weatherService.weatherDescription(weather.current_weather.weathercode))
        Text("\(weather.current_weather.windspeed) km/h")
      } else {
        Text("Search for a city to see weather")
      }
    }
  }
}

struct TodayView: View {
  @ObservedObject var weatherService: WeatherService

  var body: some View {
    VStack {
      Text("Today")
        .font(.largeTitle)

      if let loc = weatherService.selectedLocation, let hourly = weatherService.weatherInfo?.hourly {
        Text("\(loc.name), \(loc.country)")
        List(0..<hourly.time.count, id: \.self) { i in
          HStack {
            Text(hourly.time[i].suffix(5))
            Spacer()
            Text(weatherService.weatherDescription(hourly.weathercode[i]))
            Spacer()
            Text("\(Int(hourly.temperature_2m[i]))°C")
            Text("\(Int(hourly.windspeed_10m[i])) km/h").font(.caption)
          }
        }
      }
    }
  }
}

struct WeeklyView: View {
  @ObservedObject var weatherService: WeatherService

  var body: some View {
    VStack {
      Text("Weekly")
        .font(.largeTitle)

      if let loc = weatherService.selectedLocation, let daily = weatherService.weatherInfo?.daily {
        Text("\(loc.name), \(loc.country)")
        List(0..<daily.time.count, id: \.self) { i in
          HStack {
            Text(daily.time[i])
            Spacer()
            Text(weatherService.weatherDescription(daily.weathercode[i]))
            Spacer()
            VStack {
              Text("Max: \(Int(daily.temperature_2m_max[i]))°C")
              Text("Min: \(Int(daily.temperature_2m_min[i]))°C").font(.caption)
            }
          }
        }
      }
    }
  }
}
