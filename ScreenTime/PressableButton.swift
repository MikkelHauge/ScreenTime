//
//  PressableButton.swift
//  ScreenTime
//
//  Created by Mikkel Hauge on 22/07/2025.
//

import SwiftUI


struct PressableButton: View {
    let title: LocalizedStringKey
    let color: Color
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(color.opacity(0.6))
                .frame(height: 60)

            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(color.opacity(1))
                .frame(height: 60)
                .offset(y: isPressed ? 0 : -6)
                .overlay(
                    Text(title)
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 16) // 👈 internal horizontal padding
                        .offset(y: isPressed ? 0 : -6)
                        .multilineTextAlignment(.center)
                    
                )
        }
        .frame(maxWidth: 200) // 👈 optionally control max width
        .onTapGesture {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                isPressed = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }
    }
}

#Preview {
    ContentView()
}
