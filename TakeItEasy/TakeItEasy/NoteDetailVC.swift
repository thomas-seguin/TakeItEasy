//
//  ViewController.swift
//  NoteAppCoreData
//
//  Created by MAC on 2022-06-09.
//

import UIKit
import CoreData
import Speech

class NoteDetailVC: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var descTV: UITextView!
    
    var irow = 0
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    //For Speech-To-Text Conversion
    let audioEngine = AVAudioEngine()
    let speechRecog = SFSpeechRecognizer()
    let bufferRecogReq = SFSpeechAudioBufferRecognitionRequest()
    var recogTask : SFSpeechRecognitionTask!
    var isStart = false
    
    
    var selectedNote: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (selectedNote != nil){
            titleTF.text = selectedNote?.title
            descTV.text = selectedNote?.desc
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
    

         if (selectedNote == nil){

             let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context!) as! Note
             newNote.title = titleTF.text
             newNote.desc = descTV.text
             newNote.username = UserSingleton.userData.currentUsername
             
             //assigning date to createdAt
             newNote.createdAt = Date()
             
             do{
                 try context!.save()
                 print("print something")
                 arrayObject.append(newNote)
                 navigationController?.popViewController(animated: true)
                 
             }catch{
                 print("context save error")
                 
             }
         }else{//edit
             let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
             do{
                 let results: NSArray = try context!.fetch(request) as NSArray
                 for result in results{
                     let note = result as! Note
                     if (note == selectedNote){
                         note.title = titleTF.text
                         note.desc = descTV.text
                         try context!.save()
                         navigationController?.popViewController(animated: true)
                     }
                 }
             } catch {
                 print("Fetch Failed")
             }
         }
     }
    
    
     
    @IBAction func DeleteNote(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        request.predicate =  NSPredicate(format: "title == %@", selectedNote!.title)
        do{
            let noteObj = try context.fetch(request)
            if (noteObj.count != 0 ){
                context.delete(noteObj.first as! Note)
                try context.save()
                print("Note deleted")
                arrayObject.remove(at: irow)
                navigationController?.popViewController(animated: true)
                
            }else{
                print("Note not found")
                
            }
        }catch{
            print("error in deleting note")
            
        }
    }
    
     
    
    //Functions to set-up speech-to-text
    func startSpeechRecog(){
        let inputN = audioEngine.inputNode
        let recordF = inputN.outputFormat(forBus: 0)
        inputN.installTap(onBus: 0, bufferSize: 1024, format: recordF){
            buffer, _ in
            self.bufferRecogReq.append(buffer)
        }
        audioEngine.prepare()
        do{
            try audioEngine.start()
            
        } catch{
            print ("error")
        }
    
        recogTask = speechRecog?.recognitionTask(with: bufferRecogReq, resultHandler: { resp, error in
            guard let res = resp else{
                print (error)
                return
            }
            
            let msg = resp?.bestTranscription.formattedString
            self.descTV.text = msg
            
            var colorValue = ""
            for str in resp!.bestTranscription.segments{
                let indexTo = msg!.index(msg!.startIndex, offsetBy : str.substringRange.location)
                colorValue = String(msg![indexTo...])
            }
            
        })
        
        isStart = true
    }
    
    
    //Function to halt speech-to-text
    func cancellSpeech(){
        recogTask.finish()
        recogTask.cancel()
        recogTask = nil
        bufferRecogReq.endAudio()
        audioEngine.stop()
        if audioEngine.inputNode.numberOfInputs > 0{
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        isStart = false
    }
    
    
    @IBAction func startRecording(_ sender: Any) {
        
        if isStart{
            cancellSpeech()
        }
        else{
            startSpeechRecog()
        }
    }
    
    
    
}

