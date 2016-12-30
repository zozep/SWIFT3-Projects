//
//  ViewController.swift
//  SpeechRecognizer
//
//  Created by Joseph Park on 12/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit
import Speech
import AVFoundation


class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var transcriptionTextField: UITextView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.isHidden = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        activitySpinner.stopAnimating()
        activitySpinner.isHidden = true
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                
                //giving url path to find the file
                if let path = Bundle.main.url(forResource: "testSound", withExtension: "m4a") {
                    
                    //play the audio file, but analysis is not yet done
                    do {
                        let sound = try AVAudioPlayer(contentsOf: path)
                        //self because going inside of closure
                        self.audioPlayer = sound
                        self.audioPlayer.delegate = self
                        sound.play()
                    } catch {
                        print("Error!")
                    }
                    
                    //set up recognizer, request and task -> REQUIRED
                    guard let recognizer = SFSpeechRecognizer() else {
                        return
                    }
                    
                    if !recognizer.isAvailable {
                        print("Speech recognition not available")
                        return
                    }
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    request.shouldReportPartialResults = true
                    recognizer.recognitionTask(with: request) { (result, error) in
                        guard error == nil else {
                            print("Error: \(error)"); return
                        }
                        guard let result = result else {
                            print("No result!"); return
                        }
                        
                        print(result.bestTranscription.formattedString)
                        self.transcriptionTextField.text = result.bestTranscription.formattedString
                    }
                }
            }
        }
    }
    
    @IBAction func playButtonTapped(_ sender: AnyObject) {
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
        requestSpeechAuthorization()
    }
    
}

