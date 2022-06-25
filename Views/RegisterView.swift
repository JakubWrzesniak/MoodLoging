//
//  RegisterView.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 23/02/2022.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authenticator: Authenticator
    @ObservedObject private var userRegistrationModelView = UserRegistartionViewModel()
    @Binding var currentPage: StartingPages
    @State var isLoading = false
    @State var errorMessage = ""
    
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
                if !errorMessage.isEmpty {
                    RequirementText(iconColor: Color("Danger"), text: errorMessage)
                }
            }
            .padding()
            .padding(.bottom, 50)
            
            if(userRegistrationModelView.areAllContraintMet()){
                Button(action: {
                    isLoading = true
                    Task{
                        do{
                            try await authenticator.register(username: userRegistrationModelView.username, password: userRegistrationModelView.password)
                            await userRegistrationModelView.addNewUserToDatabase(viewContext: viewContext)
                            try await authenticator.login(username: userRegistrationModelView.username, password: userRegistrationModelView.password)
                        } catch {
                            self.errorMessage = error.localizedDescription
                        }
                        isLoading = false
                    }
                }) {
                    HStack{
                        Text("Sign Up")
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
                    Text("Sign Up")
                        .bold()
                }
                .buttonStyle(DisabledButtonStyle())
            }
        }
        Button(action: {
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
