//
//  WeatherStateView.swift
//  WeatherApp
//
//  Created by Sergej Gavrilov on 17.04.26.
//

import SwiftUI

struct WeatherStateView<Content: View>: View {
  @EnvironmentObject var weatherService: WeatherService
  @EnvironmentObject var locationManager: LocationManager
  let content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    if let apiError = weatherService.errorMessage {
      Text(apiError)
        .foregroundColor(.red)
        .multilineTextAlignment(.center)
        .padding()
    } else if let locError = locationManager.errorMessage{
      Text(locError)
        .foregroundColor(.orange)
        .multilineTextAlignment(.center)
    } else if weatherService.selectedLocation != nil && weatherService.weatherInfo != nil {
      content
    } else {
      Text("Search for a city to see the weather")
        .foregroundColor(.gray)
    }

  }
}
