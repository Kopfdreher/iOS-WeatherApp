//
//  LocationManager.swift
//  mobileModule02
//
//  Created by Sergej Gavrilov on 15.04.26.
//

import SwiftUI
import Combine
import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  private let manager = CLLocationManager()

  @Published var location: CLLocationCoordinate2D?
  @Published var authorizationStatus: CLAuthorizationStatus?
  @Published var errorMessage: String?

  override init() {
    super.init()
    manager.delegate = self
  }

  func requestLocation() {
    self.location = nil
    manager.requestWhenInUseAuthorization()
    manager.requestLocation()
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationStatus = manager.authorizationStatus
    if authorizationStatus == .denied || authorizationStatus == .restricted {
      errorMessage = "Location services are disabled for this app."
    } else {
      errorMessage = nil
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    location = locations.first?.coordinate
    errorMessage = nil
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location error: \(error.localizedDescription)")
  }
}
