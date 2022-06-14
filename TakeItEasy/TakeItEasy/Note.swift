//
//  Note.swift
//  TakeItEasy
//
//  Created by MAC on 2022-06-14.
//

import CoreData

@objc (Note)
class Note: NSManagedObject{
    
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var desc: String!
    @NSManaged var deletedDate: Date?
    @NSManaged var createdAt: Date?
    
    
    
}

