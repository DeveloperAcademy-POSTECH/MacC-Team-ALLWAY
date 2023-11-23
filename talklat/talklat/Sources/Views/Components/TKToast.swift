//
//  TKToast.swift
//  talklat
//
//  Created by Celan on 11/14/23.
//

import SwiftData
import SwiftUI

struct TKToast: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isPresented: Bool
    let title: String
    let locationInfo: String
    
    var body: some View {
        if isPresented {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        Color.white,
                        Color.OR5
                    )
                    .padding(.leading, 16)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(Color.white)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                        
                        Text("\(locationInfo)")
                        +
                        Text("에 대화가 저장되었어요.")
                    }
                    .font(.caption2)
                    .foregroundStyle(colorScheme == .light ? Color.GR4 : Color.GR6)
                }
            }
            .padding(.horizontal, 16)
            .frame(
                maxWidth: .infinity,
                maxHeight: 65,
                alignment: .leading
            )
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(colorScheme == .light ? Color.GR7 : Color.GR3)
                    .padding(.horizontal, 16)
            }
            .transition(
                .move(edge: .top)
                .combined(with: .opacity)
            )
            .onTapGesture {
                dismissToast()
            }
            .task {
                try? await Task.sleep(for: .seconds(2.5))
                dismissToast()
            }
        }
    }
    
    private func dismissToast() {
        withAnimation {
            if isPresented {
                isPresented = false
            }
        }
    }
}

#Preview {
    TKToast(
        isPresented: .constant(false),
        title: "TITLE",
        locationInfo: "LOCATION"
    )
}
