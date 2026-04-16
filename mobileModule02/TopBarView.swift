//
//  TopBarView.swift
//  mobileModule02
//
//  Created by Sergej Gavrilov on 15.04.26.
//

import Combine
import SwiftUI

struct TopBarView: View {
  @Binding var searchInput: String
  @Binding var submittedText: String
  @ObservedObject var locationManager: LocationManager
  @ObservedObject var weatherService: WeatherService

  var body: some View {
    HStack {
      TextField("Search location...", text: $searchInput)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .onChange(of: searchInput) { oldValue, newValue in
          weatherService.fetchCities(query: newValue)
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
          weatherService: weatherService
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
  @ObservedObject var weatherService: WeatherService

  var body: some View {
    List(weatherService.suggestions) { location in
      Button(action: {
        submittedText = "\(location.name), \(location.admin1 ?? "") \(location.country)"
        searchInput = ""
        weatherService.suggestions = []
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
    .background(.ultraThinMaterial)
    .frame(height: 200)
  }
}
