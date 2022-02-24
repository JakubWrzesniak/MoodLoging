//
//  UserLoginViewModel.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 24/02/2022.
//

import Foundation
import Combine

class UserLoginViewModel: ObservableObject{
    @Published var username = ""
    @Published var password = ""
    
    @Published var isUsernameLengthCorrect = false
    @Published var isPasswordLengthCorrect = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(){
        $username.receive(on: RunLoop.main)
            .map { username in
                username.count > 4
            }
            .assign(to: \.isUsernameLengthCorrect, on: self)
            .store(in: &cancellableSet)
        $password.receive(on: RunLoop.main)
            .map { password in
                password.count > 4
            }
            .assign(to: \.isPasswordLengthCorrect, on: self)
            .store(in: &cancellableSet)
    }
}
