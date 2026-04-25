//
//  WeatherAppView.swift
//  WeatherApp
//
//  Created by Sergej Gavrilov on 15.04.26.
//

import SwiftUI
import CoreLocation

struct WeatherAppView: View {
  @State private var selectedTab = 0
  @State private var searchInput = ""
  @State private var submittedText = ""

  @StateObject private var locationManager = LocationManager()
  @StateObject private var weatherService = WeatherService()

  var body: some View {
    ZStack {

      Image("AppBackground")
        .resizable()
        .ignoresSafeArea()
        .overlay(Color.black.opacity(0.0))

      VStack(spacing: 0) {
        TopBarView(searchInput: $searchInput, submittedText: $submittedText)
        SwipeTabView(selectedTab: $selectedTab)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        BottomBarView(selectedTab: $selectedTab)
      }
    }
    .environmentObject(locationManager)
    .environmentObject(weatherService)
    .onChange(of: locationManager.location?.latitude) { _, _ in
      if let coord = locationManager.location {
        let gpsLoc = Location(
          id: 0,
          name: "Current Location",
          admin1: nil,
          country: "",
          latitude: coord.latitude,
          longitude: coord.longitude
        )
        weatherService.fetchWeather(for: gpsLoc)
      }
    }
  }
}

#Preview {
  WeatherAppView()
}
