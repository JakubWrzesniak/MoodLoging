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
    
    @Published var isUsernameCorrect = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(){
        $username.receive(on: RunLoop.main)
            .map { username in
                let pattern = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
                if let _ = username.range(of: pattern, options: .regularExpression){
                    return true
                } else {
                    return false
                }
            }
            .assign(to: \.isUsernameCorrect, on: self)
            .store(in: &cancellableSet)
    }
}
