//
//  WakingTimes+CoreDataProperties.swift
//  MoodLoging
//
//  Created by Jakub Wrześniak on 24/02/2022.
//
//

import Foundation
import CoreData


extension WakingTimes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WakingTimes> {
        return NSFetchRequest<WakingTimes>(entityName: "WakingTimes")
    }

    @NSManaged public var time: Date
    @NSManaged public var user: UserDetails?
    @NSManaged public var events: NSSet?

}

// MARK: Generated accessors for events
extension WakingTimes {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

extension WakingTimes : Identifiable {

}
