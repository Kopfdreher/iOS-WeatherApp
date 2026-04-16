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
  let submittedText: String
  @ObservedObject var locationManager: LocationManager
  let titles = ["Currently", "Today", "Weekly"]

  var body: some View {
    TabView(selection: $selectedTab) {
      ForEach(0..<titles.count, id: \.self) { index in
        VStack {
          Text(titles[index])
            .font(.largeTitle)
            .padding(.bottom, 20)
          if (!submittedText.isEmpty) {
            Text(submittedText)
              .font(.title)
          } else if let error = locationManager.errorMessage {
            Text("Geolocation: \(error)")
              .font(.title)
              .multilineTextAlignment(.center)
          } else if let location = locationManager.location {
            Text("Geolocation:\nLat: \(location.latitude)\nLon: \(location.longitude)")
              .font(.title)
              .multilineTextAlignment(.center)
              .padding(.horizontal, 24)
          } else {
            Text("Geolocation")
              .font(.title)
          }
        }
        .tag(index)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
}
