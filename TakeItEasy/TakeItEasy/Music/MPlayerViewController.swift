//
//  MPlayerViewController.swift
//  TakeItEasy
//
//  Created by Dhananjay H. Roy on 2022-06-20.
//

import UIKit
import AVFoundation


var incomingTemp = ""
class MPlayerViewController: UIViewController {

    @IBOutlet weak var CurrentSongLabel: UILabel!
    
    @IBOutlet weak var EndTimer: UILabel!
    @IBOutlet weak var beginTimer: UILabel!
    @IBOutlet weak var albumImg: UIImageView!
   
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var currentSongTimeSlider: UISlider!
    @IBOutlet weak var currentSongImg: UIImageView!
    @IBOutlet weak var previousSongPlay: UIButton!
    @IBOutlet weak var nextSongPlay: UIButton!
    
    let seekDuration: Int = 10
    
    var audioPlayer : AVAudioPlayer?
    var musicFile : String?
    var timer : Timer?
    
    var incomingTemp2 = ""
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        
        let filePath = Bundle.main.path(forResource: musicFile, ofType: "mp3")
        let newURL = URL(fileURLWithPath: filePath!)
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: newURL)
        }
        catch
        {
            print("file not found")
        }
        albumImg.image = UIImage(named: incomingTemp2)
        CurrentSongLabel.text = musicFile
        
        currentSongTimeSlider.maximumValue = Float(audioPlayer!.duration)
        
        }
    
    @IBAction func LogOutButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.present(nextViewController, animated:true, completion:nil)
    }

    
    @IBAction func PlayMusic(_ sender: Any) {
        if audioPlayer?.isPlaying == false
        {
            audioPlayer?.play()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
        else if audioPlayer?.isPlaying == true
        {
            audioPlayer?.pause()
            print("Music Pause")
        }
       
    }
    
    @objc func updateTime()
    {
        let currentTime = Int(audioPlayer!.currentTime)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        
        beginTimer.text = String(format: "%02d:%02d", minutes,seconds) as String
        
        let eTimer = Int(audioPlayer!.duration)
        let eMinutes = (eTimer/60)
        let eSeconds = (eTimer % 60) % 60
        EndTimer.text = String(format: "%02d:%02d", eMinutes,eSeconds) as String
        
        currentSongTimeSlider.value = Float(audioPlayer!.currentTime)
    }
    
    @IBAction func volumeSilderControl(_ sender: UISlider) {
        audioPlayer!.volume = sender.value
    }
    
    
    @IBAction func songSliderControl(_ sender: UISlider) {
      //currentSongTimeSlider
        audioPlayer?.stop()
        audioPlayer?.currentTime = TimeInterval(currentSongTimeSlider.value)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
      
    }
    
    func updateSongSlider()
    {
        currentSongTimeSlider.value = Float(audioPlayer!.currentTime)
    }
    
    
    @IBAction func nextSong(_ sender: Any) {
        
        audioPlayer?.stop()
        audioPlayer?.currentTime = TimeInterval(currentSongTimeSlider.value + 10)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }
    @IBAction func previousSong(_ sender: Any) {
        
        audioPlayer?.stop()
        audioPlayer?.currentTime = TimeInterval(currentSongTimeSlider.value - 10)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = audioPlayer {
            player.stop()
        }
    }
    
   
    
    
    
    
}




