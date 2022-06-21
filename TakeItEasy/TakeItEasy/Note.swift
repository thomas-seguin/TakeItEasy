//
//  Note.swift
//  TakeItEasy
//
//  Created by MAC on 2022-06-15.
//

import CoreData

@objc (Note)
class Note: NSManagedObject{
    
    @NSManaged var title: String!
    @NSManaged var desc: String!
    @NSManaged var createdAt: Date?
    @NSManaged var username: String!
    
    
    
}
