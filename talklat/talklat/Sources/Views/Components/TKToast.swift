//
//  TKToast.swift
//  talklat
//
//  Created by Celan on 11/14/23.
//

import SwiftUI

struct TKToast: View {
    @Binding var isPresented: Bool
    let text: String = "Location"
    
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
                    Text("TITLE")
                        .font(.headline)
                        .foregroundStyle(Color.white)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                        
                        Text("\(text)")
                        +
                        Text("에 대화가 저장되었어요.")
                    }
                    .font(.caption2)
                    .foregroundStyle(Color.gray400)
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
                    .foregroundStyle(Color.gray700)
                    .padding(.horizontal, 16)
            }
            .transition(
                .move(edge: .top)
                .combined(with: .opacity)
            )
            .task {
                try? await Task.sleep(for: .seconds(2.0))
                withAnimation {
                    isPresented.toggle()
                }
            }
        }
    }
}

#Preview {
    TKToast(isPresented: .constant(false))
}
