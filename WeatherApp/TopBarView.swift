//
//  TopBarView.swift
//  WeatherApp
//
//  Created by Sergej Gavrilov on 15.04.26.
//

import Combine
import SwiftUI

struct TopBarView: View {
  @Binding var searchInput: String
  @Binding var submittedText: String
  @EnvironmentObject var locationManager: LocationManager
  @EnvironmentObject var weatherService: WeatherService

  var body: some View {
    HStack {
      TextField("Search location...", text: $searchInput)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .task(id: searchInput){
          do {
            try await Task.sleep(for: .milliseconds(300))
            weatherService.fetchCities(query: searchInput)
          } catch {}
        }
        .onSubmit {
          if let firstResult = weatherService.suggestions.first {
            submittedText = "\(firstResult.name), \(firstResult.country)"
            weatherService.fetchWeather(for: firstResult)
            weatherService.suggestions = []
            searchInput = ""
          }
        }
      Button(action: {
        submittedText = ""
        locationManager.requestLocation()
      }) {
        Image(systemName: "location.fill")
          .padding(.horizontal)
      }
    }
    .padding()
    .overlay(alignment: .top) {
      if !weatherService.suggestions.isEmpty && !searchInput.isEmpty {
        SuggestionListView(
          searchInput: $searchInput,
          submittedText: $submittedText,
        )
        .offset(y: 60)
      }
    }
    .zIndex(1)
  }
}

struct SuggestionListView: View {
  @Binding var searchInput: String
  @Binding var submittedText: String
  @EnvironmentObject var weatherService: WeatherService

  var body: some View {
    List(weatherService.suggestions) { location in
      Button(action: {
        submittedText = "\(location.name), \(location.admin1 ?? "") \(location.country)"
        searchInput = ""
        weatherService.suggestions = []
        weatherService.fetchWeather(for: location)
      }) {
        VStack(alignment: .leading) {
          Text(location.name).bold()
          Text("\(location.admin1 ?? ""), \(location.country)")
            .font(.caption)
            .foregroundStyle(.gray)
        }
      }
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .background(.clear)
    .scrollDismissesKeyboard(.interactively)
    .frame(height: 200)
  }
}
