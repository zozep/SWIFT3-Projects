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


class ViewController: UIViewController {

    @IBOutlet weak var transcriptionTextField: UITextView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.isHidden = true
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                
                //giving url path to find the file
                if let path = Bundle.main.url(forResource: "testSpeech", withExtension: "m4a") {
                    
                    //play the audio file, but analysis is not yet done
                    do {
                        let sound = try AVAudioPlayer(contentsOf: path)
                        //self because going inside of closure
                        self.audioPlayer = sound
                        sound.play()
                    } catch {
                        print("Error!")
                    }
                    
                    //set up recognizer, request and task -> REQUIRED
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    recognizer?.recognitionTask(with: request) { (result, error) in
                        //if error top the app, print errror
                        if let error = error {
                            print("There was an error: \(error)")
                        } else {
                            print(result?.bestTranscription.formattedString)
                        }
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

