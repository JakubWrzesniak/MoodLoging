//
//  ClockView.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 25/02/2022.
//

import SwiftUI

struct ClockView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var fetchRequest: FetchRequest<WakingTimes>
    var wakingTimes: FetchedResults<WakingTimes> {
        fetchRequest.wrappedValue
    }
    var formatter: DateFormatter {
        let dt = DateFormatter()
        dt.dateFormat = "a"
        return dt
    }
    
    init(user: UserDetails){
        let predicate = NSPredicate(format: "user == %@", user)
        self.fetchRequest = FetchRequest(entity: WakingTimes.entity(), sortDescriptors: [], predicate: predicate, animation: .default)
    }
    
    var body: some View {
        GeometryReader { geometry in
        ZStack{
            Circle()
                .stroke(Color.init(white: 0, opacity: 0))
                .frame(minWidth:0, maxWidth: .infinity)
                .padding(30)
            ForEach(1 ..< 13){ number in
                Text("\(number)").font(.system(.title2, design: .rounded)).bold()
                    .frame(width: 30, height: 30)
                    .rotationEffect(.degrees((Double(number) * -30)+1))
                    .offset(y: -140)
                    .rotationEffect(.degrees((Double(number) * 30)-1))
            }
            ForEach(13 ..< 25){ number in
                Text("\(number)").font(.system(.body, design: .rounded))
                    .frame(width: 30, height: 30)
                    .rotationEffect(.degrees((Double(number) * -30)+1))
                    .offset(y: -100)
                    .rotationEffect(.degrees((Double(number) * 30)-1))
            }
            ForEach(wakingTimes){ t in
                SelectedHourCircle(date: t.time)
                    .gesture(DragGesture().onChanged{ (value) in
                      //  let quoter = getQuoter(x0: geometry.size., y0: <#T##CGFloat#>, x1: <#T##CGFloat#>, y1: <#T##CGFloat#>)
                        print(value.startLocation.y)
                        print(value.translation.height)
                        let x = value.translation.height
                        let y = value.translation.width
                        let movedDegree = (x > 0 && y < 0 || x < 0 && y > 0 ? -1 : 1 ) - ((x * x + y * y)/(formatter.string(from: t.time).lowercased().contains("am") ? -139 : -99))/2
                     //   t.time = Calendar.current.date(byAdding: DateComponents(minute: Int(movedDegree * 2)), to: t.time)!
                        
                    })
            }
        }
        }
    }
}

func getQuoter(x0: CGFloat, y0:CGFloat, x1: CGFloat, y1: CGFloat) -> Int{
    if(x1 < x0){
        if (y1 > y0){
            return 4
        } else {
            return 3
        }
    } else {
        if (y1 > y0){
            return 1
        } else {
            return 2
        }
    }
}

func getDirection(_ x: CGFloat, _ y: CGFloat) -> Int{
    if y < 0{
        if x > 0 {
            return -1
        } else {
            return 1
        }
    } else {
        if x > 0 {
            return 1
        } else {
            return -1
        }
    }
}

struct SelectedHourCircle : View{
    var date: Date
    var body: some View {
        Circle()
            .stroke(isHourAm(date) ? .teal : .indigo)
            .frame(width: 30, height: 30)
            .shadow(color:  isHourAm(date) ? .teal : .indigo, radius: 5)
            .offset(y: isHourAm(date) ? -139 : -99)
            .rotationEffect(.degrees(getXPositionFromDate(date) ?? 0))
    }
    
    func getXPositionFromDate(_ date: Date) -> CGFloat? {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        guard let hour = components.hour else {
            return nil
        }
        guard let minutes = components.minute else {
            return nil
        }
        let normalizedHour = hour % 12
        let totaltime = normalizedHour * 60 + minutes
        let fraction = Float(totaltime) / Float(12 * 60)
        let degrees = fraction * 360
        return CGFloat(degrees)
    }
    
    func isHourAm(_ date: Date) -> Bool{
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        let dateString = formatter.string(from: date)
       // let hour = Int(dateString)
        return dateString.lowercased().contains("am")
    }
}

struct ClockView_Previews: PreviewProvider {
    static var user: UserDetails {
        let newUser = UserDetails(context: PersistenceController.preview.container.viewContext)
        let newDate = WakingTimes(context: PersistenceController.preview.container.viewContext)
        newDate.time = Date()
        newDate.user = newUser
        return newUser
    }
    static var previews: some View {
        ClockView(user: user)
    }
}
