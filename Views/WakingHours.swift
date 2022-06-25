//
//  WakingHours.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 24/02/2022.
//

import SwiftUI
import Firebase

struct WakingHours: View {
    @Environment(\.managedObjectContext) private var viewContext
    var fetchRequest: FetchRequest<UserDetails>
    var user: FetchedResults<UserDetails>.Element? {
        fetchRequest.wrappedValue.first
    }
    
    init(username: String){
        let predicate = NSPredicate(format: "username == %@", username)
        self.fetchRequest = FetchRequest(entity: UserDetails.entity(), sortDescriptors: [], predicate: predicate, animation: .default)
    }
    
    var body: some View {
        VStack{
            if let wakingTimes = user?.wakingTimes{
                List{
                    ForEach(wakingTimes.array as! [WakingTimes]){ wt in
                        WakingTime(wakingTime: wt)
                    }
                }
                .onAppear() {
                    UITableView.appearance().backgroundColor = UIColor.clear
                    UITableViewCell.appearance().backgroundColor = UIColor.clear
                }
                ClockView(user: user!)
            }
            Button(action: {addItem()}){
                Text("Add")
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            if let user = user{
                let newItem = WakingTimes(context: viewContext)
                newItem.time = Date()
                user.addToWakingTimes(newItem)
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
}

struct WakingHours_Previews: PreviewProvider {
    static var previews: some View {
        WakingHours(username: "test@wp.po")
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
