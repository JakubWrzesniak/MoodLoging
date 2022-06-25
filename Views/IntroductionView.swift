//
//  IntroductionView.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 25/02/2022.
//

import SwiftUI
import Firebase

struct IntroductionView: View {
    var username: String
    @State private var selection = 0
    
    var body: some View {
        ZStack(alignment: .bottom){
            TabView(selection: $selection){
                IntroductionWelcomeView(username: username).tag(0)
                WakingHours(username: username).tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
        }
    }
}

struct IntroductionWelcomeView: View{
    var username: String
    
    var body: some View {
        VStack(spacing: 30){
            Text("Welcome \(username)")
                .font(.system(.largeTitle, design: .rounded))
            Text("Start introducing to Mood login app.")
                .multilineTextAlignment(.center)             .font(.system(.title, design: .rounded))
            Spacer()
        }
        .padding(.top, 100)
    }
}

struct IntroductionWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionWelcomeView(username: "test@wp.po")
    }
}
