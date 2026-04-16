//
//  BottomBarView.swift
//  mobileModule02
//
//  Created by Sergej Gavrilov on 15.04.26.
//

import Combine
import SwiftUI

struct BottomBarView: View {
  @Binding var selectedTab: Int
  let titles = ["Currently", "Today", "Weekly"]
  let icons = ["clock.fill", "calendar.circle.fill", "calendar"]

  var body: some View {
    HStack {
      ForEach(0..<titles.count, id: \.self) { index in
        Spacer()
        BottomBarIconView(
          iconName: icons[index],
          title: titles[index],
          tabIndex: index,
          selectedTab: $selectedTab
        )
      }
      Spacer()
    }
    .padding(.vertical, 10)
    .background(Color(UIColor.systemGray6))
  }
}

struct BottomBarIconView: View {
  let iconName: String
  let title: String
  let tabIndex: Int
  @Binding var selectedTab: Int

  var body: some View {
    Button(action: {
      selectedTab = tabIndex
    }) {
      VStack {
        Image(systemName: iconName)
          .font(.system(size: 20))
        Text(title)
          .font(.caption)
      }
      .foregroundColor(selectedTab == tabIndex ? .blue : .gray)
    }
  }
}
