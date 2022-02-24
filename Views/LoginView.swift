//
//  LoginView.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 24/02/2022.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @ObservedObject private var userLoginViewModel = UserLoginViewModel()
    @State private var errorDecription: String = ""
    @Binding var currentPage: StartingPages
    
    var body: some View {
        VStack{
            Text("Login in")
                .font(.system(.largeTitle, design: .rounded))
                .bold()
                .padding(.bottom, 30)
            
            FormField(fieldName: "Username", fieldValue: $userLoginViewModel.username, isSecure: false)
            RequirementText(iconColor: userLoginViewModel.isUsernameCorrect ? .secondary : Color(red: 251/255, green: 128/255, blue: 128/255), text: "Incorrect email address", isStrikeThrought: userLoginViewModel.isUsernameCorrect)
                .padding()
            
            FormField(fieldName: "Password", fieldValue: $userLoginViewModel.password, isSecure: true)
            if !errorDecription.isEmpty {
                RequirementText(iconColor: Color(red: 251/255, green: 128/255, blue: 128/255), text: errorDecription, isStrikeThrought: false)
                    .padding()
            }
            
            Button(action: {
                Auth.auth().signIn(withEmail: userLoginViewModel.username, password: userLoginViewModel.password) { (result, error) in
                    if let error = error {
                        errorDecription = error.localizedDescription
                    } else {
                        errorDecription = ""
                    }
                    
                    if let result = result {
                        print("RESULTS: ")
                        print(result.user.displayName ?? "")
                    } else {
                        print("Missing results")
                    }
                }
            }) {
                Text("Sign In")
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(red: 251/255, green: 128/255, blue: 128/255), Color(red: 253/255, green: 193/255, blue: 104/255)]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            Button(action: {currentPage = .registerPage}) {
                Text("Sign Up")
            }
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
