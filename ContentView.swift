//
//  ContentView.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 23/02/2022.
//

import SwiftUI
import CoreData
import Firebase

struct ContentView: View {
    @EnvironmentObject var authenticator: Authenticator
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var startingPage: StartingPages = .loginPage

    
    var body: some View {
        Group{
            Text("Welcome \(Auth.auth().currentUser?.email ?? "Brak email")")
            Button(action: {authenticator.logout()}){
                Text("Logout")
            }
        }.fullScreenCover(isPresented: $authenticator.needsAuthentication){
            switch startingPage {
                case .loginPage:
                    LoginView(currentPage: $startingPage)
                        .environmentObject(authenticator)
                case .registerPage:
                    RegisterView(currentPage: $startingPage)
                        .environmentObject(authenticator)
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

enum StartingPages { case loginPage, registerPage}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(Authenticator())
    }
}
