//
//  View+Keyboard.swift
//  talklat
//
//  Created by Celan on 10/23/23.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
