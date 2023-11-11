//
//  EnvironmentValues+Namespace.swift
//  talklat
//
//  Created by Celan on 11/12/23.
//

import SwiftUI

struct NamespaceEnvironmentKey: EnvironmentKey {
    static var defaultValue: Namespace.ID = Namespace().wrappedValue
}

extension EnvironmentValues {
    var namespace: Namespace.ID {
        get { self[NamespaceEnvironmentKey.self] }
        set { self[NamespaceEnvironmentKey.self] = newValue }
    }
}

extension View {
    func publishNamespace(_ value: Namespace.ID) -> some View {
        environment(\.namespace, value)
    }
}
