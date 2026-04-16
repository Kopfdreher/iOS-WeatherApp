//
//  WeatherAppView.swift
//  mobileModule02
//
//  Created by Sergej Gavrilov on 15.04.26.
//

import SwiftUI

struct WeatherAppView: View {
  @State private var selectedTab = 0
  @State private var searchInput = ""
  @State private var submittedText = ""

  @StateObject private var locationManager = LocationManager()
  @StateObject private var weatherService = WeatherService()

  var body: some View {
    VStack {
      TopBarView(
        searchInput: $searchInput,
        submittedText: $submittedText,
        locationManager: locationManager,
        weatherService: weatherService
      )
      SwipeTabView(
        selectedTab: $selectedTab,
        submittedText: submittedText,
        locationManager: locationManager
      )
      BottomBarView(selectedTab: $selectedTab)
    }
  }
}

#Preview {
  WeatherAppView()
}
