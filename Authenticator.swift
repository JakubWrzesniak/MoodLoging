//
//  Authenticator.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 24/02/2022.
//

import Foundation
import Firebase
import Combine

@MainActor class Authenticator: ObservableObject{
    @Published var needsAuthentication: Bool = true
    @Published var newlyRegisteredUser: Bool = false
    @Published var firstLogin: Bool = false
    @Published var user: User?
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(){
        Publishers.CombineLatest($needsAuthentication, $newlyRegisteredUser)
            .receive(on: RunLoop.main)
            .map { (needsAuth, newlyRegistered) in
                return !needsAuth && newlyRegistered
            }
            .assign(to: \.firstLogin, on: self)
            .store(in: &cancellableSet)
    }
    
    func login(username: String, password: String) async throws{
            try await Auth.auth().signIn(withEmail: username, password: password)
            self.needsAuthentication = false
            self.user = Auth.auth().currentUser
    }
    
    func register(username: String, password: String ) async throws{
        try await Auth.auth().createUser(withEmail: username, password: password)
        self.newlyRegisteredUser = true
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
