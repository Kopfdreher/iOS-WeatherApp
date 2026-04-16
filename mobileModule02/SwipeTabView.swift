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

  var body: some View {
    TabView(selection: $selectedTab) {
      CurrentlyView().tag(0)
      TodayView().tag(1)
      WeeklyView().tag(2)
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
}

struct CurrentlyView: View {
  @EnvironmentObject var weatherService: WeatherService
  @EnvironmentObject var locationManager: LocationManager

  var body: some View {
    VStack(spacing: 10) {
      Text("Currently")
        .font(.largeTitle)

      WeatherStateView {
        if let loc = weatherService.selectedLocation, let weather = weatherService.weatherInfo {
          Text("\(loc.name)")
          if let coord = locationManager.location, weatherService.selectedLocation?.name == "Current Location" {
            Text("Lat: \(coord.latitude), Lon: \(coord.longitude)")
              .font(.caption)
              .foregroundColor(.secondary)
          } else {
            Text("\(loc.admin1 ?? ""), \(loc.country)")
          }
          Text("\(Int(weather.current_weather.temperature))°C")
          Text(weatherService.weatherDescription(weather.current_weather.weathercode))
          Text("\(weather.current_weather.windspeed) km/h")
        }
      }
    }
  }
}

struct TodayView: View {
  @EnvironmentObject var weatherService: WeatherService

  var body: some View {
    VStack {
      Text("Today")
        .font(.largeTitle)

      WeatherStateView {
        if let loc = weatherService.selectedLocation, let hourly = weatherService.weatherInfo?.hourly {
          Text(loc.country.isEmpty ? loc.name : "\(loc.name), \(loc.country)")
          List(0..<min(24, hourly.time.count), id: \.self) { i in
            HStack {
              Text(hourly.time[i].suffix(5))
              Spacer()
              Text(weatherService.weatherDescription(hourly.weathercode[i]))
              Spacer()
              Text("\(Int(hourly.temperature_2m[i]))°C")
              Text("\(Int(hourly.windspeed_10m[i])) km/h").font(.caption)
            }
          }
          .listStyle(.plain)
        }
      }
    }
  }
}

struct WeeklyView: View {
  @EnvironmentObject var weatherService: WeatherService

  var body: some View {
    VStack {
      Text("Weekly")
        .font(.largeTitle)

      WeatherStateView {
        if let loc = weatherService.selectedLocation, let daily = weatherService.weatherInfo?.daily {
          Text(loc.country.isEmpty ? loc.name : "\(loc.name), \(loc.country)")
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
          .listStyle(.plain)
        }
      }
    }
  }
}
