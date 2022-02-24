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
    @State var isLoading = false
    @State var errorMessage = ""
    
    var body: some View {
        VStack{
            Text("Login in")
                .font(.system(.largeTitle, design: .rounded))
                .bold()
                .padding(.bottom, 30)
            
            Group{
                FormField(fieldName: "Username", fieldValue: $userLoginViewModel.username, isSecure: false)
                FormField(fieldName: "Password", fieldValue: $userLoginViewModel.password, isSecure: true)
                if (!errorMessage.isEmpty) {
                    RequirementText(iconColor: Color(red: 251/255, green: 128/255, blue: 128/255), text: errorMessage, isStrikeThrought: false)
                }
            }
            .padding()
            
            let isButtonActive = userLoginViewModel.isUsernameLengthCorrect && userLoginViewModel.isPasswordLengthCorrect
            
            if(isButtonActive){
                Button(action: {
                    isLoading = true
                    Task {
                        do{
                            try await authenticator.login(username: userLoginViewModel.username, password: userLoginViewModel.password)
                        } catch {
                            self.errorMessage = error.localizedDescription
                        }
                        isLoading = false
                    }
                }) {
                    HStack{
                        Text("Sign In")
                            .bold()
                        if(isLoading){
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding(.leading, 5)
                        }
                    }
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
