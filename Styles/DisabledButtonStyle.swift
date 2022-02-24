//
//  DisabledButtonStyle.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 24/02/2022.
//

import SwiftUI

struct DisabledButtonStyle: ButtonStyle {
    var primaryColor = Color("DarkGreen")
    var secondaryColor = Color("LightGreen")
    
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body, design: .rounded))
            .accentColor(.white)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 2 )
                )
            .padding(.horizontal)
            .disabled(true)
    }
}
