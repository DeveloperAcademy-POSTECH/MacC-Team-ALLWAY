//
//  View+TKAlert.swift
//  bisdam
//
//  Created by Celan on 11/23/23.
//

import SwiftUI

extension View {
    internal func showTKAlert<TKLabel: View>(
        isPresented: Binding<Bool>,
        style: TKAlert<TKLabel>.AlertStyle,
        onDismiss: @escaping () -> Void,
        confirmButtonAction: @escaping () -> Void,
        confirmButtonLabel: @escaping () -> TKLabel
    ) -> some View {
        self
            .disabled(isPresented.wrappedValue)
            .overlay {
                if isPresented.wrappedValue {
                    Color.black
                        .opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            onDismiss()
                            withAnimation {
                                isPresented.wrappedValue = false
                            }
                        }
                }
            }
            .overlay {
                if isPresented.wrappedValue {
                    TKAlert(
                        style: style,
                        isPresented: isPresented,
                        onDismiss: onDismiss,
                        confirmButtonAction: confirmButtonAction,
                        confirmButtonLabel: confirmButtonLabel
                    )
                }
            }
    }
    
    internal func showTKAlert<TKLabel: View>(
        isPresented: Binding<Bool>,
        style: TKAlert<TKLabel>.AlertStyle,
        confirmButtonAction: @escaping () -> Void,
        confirmButtonLabel: @escaping () -> TKLabel
    ) -> some View {
        self
            .disabled(isPresented.wrappedValue)
            .overlay {
                if isPresented.wrappedValue {
                    Color.black
                        .opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                isPresented.wrappedValue = false
                            }
                        }
                }
            }
            .overlay {
                if isPresented.wrappedValue {
                    TKAlert(
                        style: style,
                        isPresented: isPresented,
                        confirmButtonAction: confirmButtonAction,
                        confirmButtonLabel: confirmButtonLabel
                    )
                }
            }
    }
}
