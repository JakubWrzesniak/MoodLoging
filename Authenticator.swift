//
//  Authenticator.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 24/02/2022.
//

import Foundation
import Firebase

@MainActor class Authenticator: ObservableObject{
    @Published var needsAuthentication: Bool
    
    init(){
        self.needsAuthentication = true
    }
    
    func login(username: String, password: String) async throws{
            try await Auth.auth().signIn(withEmail: username, password: password)
            self.needsAuthentication = false
    }
    
    func register(username: String, password: String ) async throws{
        try await Auth.auth().createUser(withEmail: username, password: password)
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
            self.needsAuthentication = true
        } catch  {
            print(error.localizedDescription)
        }
    }
}
