//
//  RegisterView.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 23/02/2022.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    @EnvironmentObject var authenticator: Authenticator
    @ObservedObject private var userRegistrationModelView = UserRegistartionViewModel()
    @Binding var currentPage: StartingPages
    
    var body: some View {
        VStack{
            Text("Create an account")
                .font(.system(.largeTitle, design: .rounded))
                .bold()
                .padding(.bottom, 30)
            
            FormField(fieldName: "Username", fieldValue: $userRegistrationModelView.username)
            VStack{
                RequirementText(iconColor: userRegistrationModelView.isUsernamelengthValid ? .secondary : Color(red: 251/255, green: 128/255, blue: 128/255), text: "A minimum of 4 characters", isStrikeThrought: userRegistrationModelView.isUsernamelengthValid)
                if !userRegistrationModelView.isUsernameEmailCorrect {
                    RequirementText(iconColor: userRegistrationModelView.isUsernameEmailCorrect ? .secondary : Color(red: 251/255, green: 128/255, blue: 128/255), text: "Incorrect email pattern", isStrikeThrought: userRegistrationModelView.isUsernameEmailCorrect)
                }
            }
            .padding()
            
            FormField(fieldName: "Password", fieldValue: $userRegistrationModelView.password, isSecure: true)
            VStack{
                RequirementText(iconName: "lock.open", iconColor: userRegistrationModelView.isPasswordLengthValid ? .secondary : Color("Danger"), text: "A minimum of 8 chracters", isStrikeThrought: userRegistrationModelView.isPasswordLengthValid)
                RequirementText(iconName: "lock.open", iconColor: userRegistrationModelView.isPasswordCapitalLetter ? .secondary : Color("Danger"), text: "One uppercase letter", isStrikeThrought: userRegistrationModelView.isPasswordCapitalLetter)
            }
            .padding()
            
            FormField(fieldName: "Confirm Password", fieldValue: $userRegistrationModelView.passwordConfirmed, isSecure: true)
            VStack{
                RequirementText(iconName: userRegistrationModelView.isPasswordConfirmValid ? "checkmark.square" : "xmark.square", iconColor: userRegistrationModelView.isPasswordConfirmValid ? .green : Color("Danger"), text: "Your confirm password should be the same as the password", isStrikeThrought: userRegistrationModelView.isPasswordConfirmValid)
                if ((authenticator.error_description?.isEmpty) != nil) {
                    RequirementText(iconColor: Color("Danger"), text: authenticator.error_description!)
                }
            }
            .padding()
            .padding(.bottom, 50)
            
            if(userRegistrationModelView.areAllContraintMet()){
                Button(action: {
                    authenticator.register(username: userRegistrationModelView.username, password: userRegistrationModelView.password)
                    if((authenticator.error_description?.isEmpty) != nil){
                        authenticator.login(username: userRegistrationModelView.username, password: userRegistrationModelView.password)
                    }
                }) {
                    Text("Sign Up")
                        .bold()
                }
                .buttonStyle(PrimaryGradientButton())
            } else {
                Button(action: {}) {
                    Text("Sign Up")
                        .bold()
                }
                .buttonStyle(DisabledButtonStyle())
            }
        }
        Button(action: {
            authenticator.error_description = nil
            currentPage = .loginPage
            
        }) {
            Text("Sign In")
        }
        .padding()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView( currentPage: .constant(StartingPages.registerPage))
    }
}
