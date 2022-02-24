//
//  LoginView.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 24/02/2022.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject var authenticator: Authenticator
    @ObservedObject private var userLoginViewModel = UserLoginViewModel()
    @Binding var currentPage: StartingPages
    
    var body: some View {
        VStack{
            Text("Login in")
                .font(.system(.largeTitle, design: .rounded))
                .bold()
                .padding(.bottom, 30)
            
            Group{
                FormField(fieldName: "Username", fieldValue: $userLoginViewModel.username, isSecure: false)
                FormField(fieldName: "Password", fieldValue: $userLoginViewModel.password, isSecure: true)
                if ((authenticator.error_description?.isEmpty) != nil) {
                    RequirementText(iconColor: Color(red: 251/255, green: 128/255, blue: 128/255), text: authenticator.error_description!, isStrikeThrought: false)
                }
            }
            .padding()
            
            let isButtonActive = userLoginViewModel.isUsernameLengthCorrect && userLoginViewModel.isPasswordLengthCorrect
            
            if(isButtonActive){
                Button(action: {
                    authenticator.login(username: userLoginViewModel.username, password: userLoginViewModel.password)
                }) {
                    Text("Sign In")
                        .bold()
                }
                .buttonStyle(PrimaryGradientButton())
            } else {
                Button(action: {}) {
                    Text("Sign In")
                        .bold()
                }
                .buttonStyle(DisabledButtonStyle())
            }
            
            Button(action: {
                authenticator.error_description = nil
                currentPage = .registerPage
            }) {
                Text("Sign Up")
            }
            .padding()
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
