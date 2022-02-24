//
//  RegisterView.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 23/02/2022.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    @ObservedObject private var userRegistrationModelView = UserRegistartionViewModel()
    @Binding var currentPage: StartingPages
    
    var body: some View {
        VStack{
            Text("Create an account")
                .font(.system(.largeTitle, design: .rounded))
                .bold()
                .padding(.bottom, 30)
            
            FormField(fieldName: "Username", fieldValue: $userRegistrationModelView.username)
            RequirementText(iconColor: userRegistrationModelView.isUsernamelengthValid ? .secondary : Color(red: 251/255, green: 128/255, blue: 128/255), text: "A minimum of 4 characters", isStrikeThrought: userRegistrationModelView.isUsernamelengthValid)
                .padding()
            RequirementText(iconColor: userRegistrationModelView.isUsernameEmailCorrect ? .secondary : Color(red: 251/255, green: 128/255, blue: 128/255), text: "Incorrect email pattern", isStrikeThrought: userRegistrationModelView.isUsernameEmailCorrect)
                .padding()
            
            FormField(fieldName: "Password", fieldValue: $userRegistrationModelView.password, isSecure: true)
            VStack{
                RequirementText(iconName: "lock.open", iconColor: userRegistrationModelView.isPasswordLengthValid ? .secondary : Color(red: 251/255, green: 128/255, blue: 128/255), text: "A minimum of 8 chracters", isStrikeThrought: userRegistrationModelView.isPasswordLengthValid)
                RequirementText(iconName: "lock.open", iconColor: userRegistrationModelView.isPasswordCapitalLetter ? .secondary : Color(red: 251/255, green: 128/255, blue: 128/255), text: "One uppercase letter", isStrikeThrought: userRegistrationModelView.isPasswordCapitalLetter)
            }
            .padding()
            
            FormField(fieldName: "Confirm Password", fieldValue: $userRegistrationModelView.passwordConfirmed, isSecure: true)
            RequirementText(iconColor: userRegistrationModelView.isPasswordConfirmValid ? .secondary : Color(red: 251/255, green: 128/255, blue: 128/255), text: "Your confirm password should be the same as the password", isStrikeThrought: userRegistrationModelView.isPasswordConfirmValid)
                .padding()
                .padding(.bottom, 50)
            
            Button(action: {
                Auth.auth().createUser(withEmail: userRegistrationModelView.username, password: userRegistrationModelView.password) { authReults, error in
                    if let authReults = authReults {
                        print(authReults)
                    }
                    if let error = error {
                        print(error)
                    }
        
                }
            }) {
                Text("Sign Up")
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(red: 251/255, green: 128/255, blue: 128/255), Color(red: 253/255, green: 193/255, blue: 104/255)]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            Button(action: {currentPage = .loginPage}) {
                Text("Sign In")
            }
            
        }
    }
}

//struct RegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterView(startingPage)
//    }
//}
