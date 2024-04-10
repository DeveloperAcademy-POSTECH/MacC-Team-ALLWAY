//
//  View+LocalizeLogoFrame.swift
//  bisdam
//
//  Created by Celan on 4/10/24.
//

import SwiftUI

extension View {
  @ViewBuilder
  func localizeLogoFrame() -> some View {
    switch Locale.autoupdatingCurrent.identifier {
    case "en_US_POSIX":
      self.frame(width: 88, height: 16.6)
    case "ko_KR":
      self.frame(width: 57.4, height: 24)
    default:
      self.frame(width: 88, height: 16.6)
    }
  }
}
