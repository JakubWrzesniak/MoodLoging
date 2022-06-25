//
//  UserRegistartionViewModel.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 23/02/2022.
//

import Foundation
import Combine
import CoreData

class UserRegistartionViewModel: ObservableObject{    
    @Published var username = ""
    @Published var password = ""
    @Published var passwordConfirmed = ""
       
    @Published var isUsernamelengthValid = false
    @Published var isUsernameEmailCorrect = true
    @Published var isPasswordLengthValid = false
    @Published var isPasswordCapitalLetter = false
    @Published var isPasswordConfirmValid = false
    
    func areAllContraintMet() -> Bool {
        return isUsernamelengthValid && isUsernameEmailCorrect && isPasswordLengthValid && isPasswordCapitalLetter && isPasswordConfirmValid
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(){
        $username.receive(on: RunLoop.main)
            .map { username in
                return username.count >= 4}
            .assign(to: \.isUsernamelengthValid, on: self)
            .store(in: &cancellableSet)
        $username.receive(on: RunLoop.main)
            .map { username in
                let pattern = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
                if self.isUsernamelengthValid == false {
                    return self.isUsernameEmailCorrect
                }
                if let _ = username.range(of: pattern, options: .regularExpression){
                    return true
                } else {
                    return false
                }
            }
            .assign(to: \.isUsernameEmailCorrect, on: self)
            .store(in: &cancellableSet)
        
        $password.receive(on: RunLoop.main)
            .map { password in
                return password.count >= 8
            }
            .assign(to: \.isPasswordLengthValid, on: self)
            .store(in: &cancellableSet)
        
        $password.receive(on: RunLoop.main)
            .map { password in
                let pattern = "[A-Z]"
                if let _ = password.range(of: pattern, options: .regularExpression){
                    return true
                } else {
                    return false
                }
            }
            .assign(to: \.isPasswordCapitalLetter, on: self)
            .store(in: &cancellableSet)
        
        Publishers.CombineLatest($password, $passwordConfirmed)
            .receive(on: RunLoop.main)
            .map { (password, passwordConfirmed) in
                return !passwordConfirmed.isEmpty && (password == passwordConfirmed)
                
            }
            .assign(to: \.isPasswordConfirmValid, on: self)
            .store(in: &cancellableSet)
    }
    
    func addNewUserToDatabase(viewContext: NSManagedObjectContext) async {
        let newUser = UserDetails(context: viewContext)
        let email = self.username.lowercased()
        newUser.username = email
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
