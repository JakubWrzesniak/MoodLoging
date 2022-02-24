//
//  MoodLogingApp.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 23/02/2022.
//

import SwiftUI
import Firebase

@main
struct MoodLogingApp: App {
    @StateObject var authenticator = Authenticator()
    
    let persistenceController = PersistenceController.shared
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(authenticator)
        }
    }
}
