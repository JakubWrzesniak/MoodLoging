//
//  PrimaryGradientButton.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 24/02/2022.
//

import SwiftUI

struct PrimaryGradientButton: ButtonStyle {
    var primaryColor = Color("DarkGreen")
    var secondaryColor = Color("LightGreen")
    
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body, design: .rounded))
            .foregroundColor(.white)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [primaryColor, secondaryColor]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10)
            .padding(.horizontal)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
