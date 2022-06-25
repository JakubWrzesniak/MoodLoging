//
//  WakingTime.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 24/02/2022.
//

import SwiftUI

struct WakingTime: View {
    @ObservedObject var wakingTime: WakingTimes
    
    var body: some View {
        HStack{
            DatePicker("", selection: $wakingTime.time, displayedComponents: .hourAndMinute)
        }
    }
}

//struct WakingTime_Previews: PreviewProvider {
//    static var previews: some View {
//        WakingTime(.constant())
//    }
//}
