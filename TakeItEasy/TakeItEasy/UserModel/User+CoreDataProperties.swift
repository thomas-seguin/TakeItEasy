//
//  User+CoreDataProperties.swift
//  TakeItEasy
//
//  Created by admin on 6/10/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var fName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var verified: NSNumber?

}

extension User : Identifiable {

}
