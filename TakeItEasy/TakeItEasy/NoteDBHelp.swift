//
//  NoteDBHelp.swift
//  TakeItEasy
//
//  Created by MAC on 2022-06-14.
//


import UIKit
import CoreData

class NoteDBHelp{
    
    static var dbHelper = NoteDBHelp()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext



func getAllUserNotes() -> [Note]{
        var notes = [Note]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
//            fetchRequest.predicate = NSPredicate(format: "title == %@", searchParameter)
        do{
            notes = try context?.fetch(fetchRequest) as! [Note]
            print("data fetched")
        }
        catch{
            print("cannot fetch data")
        }
        return notes
    }
    
    func searchNote(searchParameter : String) -> [Note]{
        var notes = [Note]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchParameter)
        do{
            notes = try context?.fetch(fetchRequest) as! [Note]
            print("data fetched")
        }
        catch{
            print("cannot fetch data")
        }
        return notes
        
    }
    
}
