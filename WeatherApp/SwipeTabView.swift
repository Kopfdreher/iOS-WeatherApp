//
//  SwipeTabView.swift
//  WeatherApp
//
//  Created by Sergej Gavrilov on 15.04.26.
//

import SwiftUI
import Combine
import CoreLocation
import Charts

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
          VStack(spacing: 15) {
            Text("\(loc.name)")
              .font(.system(size: 36, weight: .bold))

            if let coord = locationManager.location, weatherService.selectedLocation?.name == "Current Location" {
              Text("Lat: \(coord.latitude), Lon: \(coord.longitude)")
                .font(.caption)
            } else {
              Text("\(loc.admin1 ?? ""), \(loc.country)")
                .font(.title3)
            }

            Image(systemName: weatherService.weatherIcon(weather.current_weather.weathercode))
              .font(.system(size: 80))
              .foregroundStyle(.yellow)
              .padding()
            Text("\(Int(weather.current_weather.temperature))°C")
              .font(.system(size: 64, weight: .bold))
            Text(weatherService.weatherDescription(weather.current_weather.weathercode))
              .font(.title2)
            Text("\(weather.current_weather.windspeed) km/h")
          }
          .foregroundColor(.primary)
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
          VStack {
            Text(loc.country.isEmpty ? loc.name : "\(loc.name), \(loc.country)")
              .font(.title2).bold()
            Chart(0..<min(24, hourly.time.count), id: \.self) { i in
              LineMark(
                x: .value("Time", String(hourly.time[i].suffix(5))),
                y: .value("Temp", hourly.temperature_2m[i])
              )
              .interpolationMethod(.catmullRom)
              .foregroundStyle(.orange)
            }
            .frame(height: 200)
            .padding()

            List(0..<min(24, hourly.time.count), id: \.self) { i in
              HStack {
                Text(hourly.time[i].suffix(5))
                Spacer()
                Image(systemName: weatherService.weatherIcon(hourly.weathercode[i]))
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
}

struct WeeklyView: View {
  @EnvironmentObject var weatherService: WeatherService

  var body: some View {
    VStack {
      Text("Weekly")
        .font(.largeTitle)

      WeatherStateView {
        if let loc = weatherService.selectedLocation, let daily = weatherService.weatherInfo?.daily {
          VStack {
            Text(loc.country.isEmpty ? loc.name : "\(loc.name), \(loc.country)")
              .font(.title2).bold()

            Chart(0..<daily.time.count, id: \.self) { i in
              LineMark(
                x: .value("Day", String(daily.time[i].suffix(5))),
                y: .value("Temp", daily.temperature_2m_max[i]),
                series: .value("Type", "Max")
                )
              .foregroundStyle(.red)
              LineMark(
                x: .value("Day", String(daily.time[i].suffix(5))),
                y: .value("Temp", daily.temperature_2m_min[i]),
                series: .value("Type", "Min")
                )
              .foregroundStyle(.blue)
            }
            .frame(height: 200)
            .padding()
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
}
