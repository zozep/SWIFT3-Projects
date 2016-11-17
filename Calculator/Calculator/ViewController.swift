//
//  ViewController.swift
//  Calculator
//
//  Created by Joseph Park on 11/15/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit
import AVFoundation

var buttonSound: AVAudioPlayer!


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        soundcheck()
    }
    
    func soundcheck() -> String! {
        let yeahUpPath = Bundle.main.path(forResource: "yeahUp", ofType: "wav")
        let yeahUpSoundURL = URL(fileURLWithPath: yeahUpPath!)
        
        let yeahDownPath = Bundle.main.path(forResource: "yeahDown", ofType: "wav")
        let yeahDownSoundURL = URL(fileURLWithPath: yeahDownPath!)
        
        let yeahPath = Bundle.main.path(forResource: "yeah", ofType: "wav")
        let yeahSoundURL = URL(fileURLWithPath: yeahPath!)

        if evenNumberPressed(sender: <#T##UIButton#>) {
            do {
                try buttonSound = AVAudioPlayer(contentsOf: yeahUpSoundURL)
                buttonSound.prepareToPlay()
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
    
        
        do {
            if oddNumberPressed(sender: UIButton) {
                try buttonSound = AVAudioPlayer(contentsOf: yeahDownSoundURL)
                    buttonSound.prepareToPlay()
                }
            }catch let err as NSError {
                    print(err.debugDescription)
            }
        
        
        do {
            if zeroPressed(sender: UIButton) {
                try buttonSound = AVAudioPlayer(contentsOf: yeahSoundURL)
                buttonSound.prepareToPlay()
            }
        }catch let err as NSError {
            print(err.debugDescription)
        }
    }

    
    @IBAction func evenNumberPressed(sender: UIButton) {
        playSound()
    }
    
    @IBAction func oddNumberPressed(sender: UIButton) {
        playSound()
    }
    
    @IBAction func zeroPressed(sender: UIButton) {
        playSound()
    }
    

    func playSound() {
        if buttonSound.isPlaying {
            buttonSound.stop()
        }
        buttonSound.play()
    }
}
