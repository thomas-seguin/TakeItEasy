//
//  NoteTableView.swift
//  TakeItEasy
//
//  Created by MAC on 2022-06-15.
//

import UIKit
import CoreData

var noteList = [Note]()
var arrayObject : [Note] = []

class NoteTableView: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var noteObject = [Note]()
    var myNotes = [Note]()
    var filteredData : [Note] = []
   
    
    var firstLoad = true
    
    func nonDeletedNotes() -> [Note]{
        var noDeleteNoteList = [Note]()
        
        for note in noteList{
            if (note.deletedDate == nil){
                noDeleteNoteList.append(note)
                
            }
        }
        
        return noDeleteNoteList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (firstLoad){
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do{
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results{
                    let note = result as! Note
                    noteList.append(note)
                }
                
                self.noteObject = try context.fetch(request) as! [Note]
                
            } catch {
                print("Fetch Failed")
            }
            for note in noteObject{
                if note.username == UserSingleton.userData.currentUsername{
                    myNotes.append(note)
                }
            }
//            noteObject = results
        }
        arrayObject = NoteDBHelp.dbHelper.getAllUserNotes()
        filteredData = noteObject
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCellID", for: indexPath) as! NoteCell
        
        let thisNote: Note!
//        thisNote = nonDeletedNotes()[indexPath.row]
        thisNote = arrayObject[indexPath.row]
        
        noteCell.titleLabel.text = thisNote.title
        noteCell.descLabel.text = thisNote.desc
        
        var formatted = DateFormatter()
        formatted.dateFormat =  "YY/MM/dd"
        
        noteCell.dateLabel.text = formatted.string(from: arrayObject[indexPath.row].createdAt!)
        noteCell.dateLabel.textColor = .systemGray
        
        
        
        return noteCell
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return nonDeletedNotes().count
        return arrayObject.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editNote"){
            let indexPath = tableView.indexPathForSelectedRow!
            
            let noteDetail = segue.destination as? NoteDetailVC
            noteDetail?.irow = indexPath.row
            
            let selectedNote : Note!
//            selectedNote = nonDeletedNotes()[indexPath.row]
            selectedNote = arrayObject[indexPath.row]
            noteDetail!.selectedNote = selectedNote
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredData = []
        
        if (searchText == ""){
//            noteObject = filteredData
            arrayObject = NoteDBHelp.dbHelper.getAllUserNotes()
        } else{
//            for searchedbar in arrayObject{
//                if searchedbar.title.lowercased().contains(searchText.lowercased()){
//                    filteredData.append(searchedbar)
//                }
            
            arrayObject = NoteDBHelp.dbHelper.searchNote(searchParameter: searchText.lowercased())
            
        }
        
        self.tableView.reloadData()
        
    }
    
//     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) {
//
//        if (editingStyle == .delete){
//            //delete from core data and delete from array and reload tableview
//            let personToDelete = arrayObject.remove(at: indexPath.row)
//            NoteDBHelp.dbHelper.context!.delete(personToDelete)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            do{
//                try NoteDBHelp.dbHelper.context!.save()
//            } catch{
//                print("deleting error")
//            }
//        }else{
//            print("deleting error")
//        }
//    }
    
    
//    Below function works
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        guard editingStyle == .delete else { return }
        let personToDelete = arrayObject.remove(at: indexPath.row)
        NoteDBHelp.dbHelper.context!.delete(personToDelete)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        do{
            try NoteDBHelp.dbHelper.context!.save()
        } catch{
            print("deleting error")
        }
    }
}
