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


public class ViewController: UIViewController {
    @IBOutlet var evenNumbersPressed: [UIButton]!
    @IBOutlet var oddNumbersPressed: [UIButton]!
    @IBOutlet weak var zeroIsPressed: UIButton!

    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    //music play related
    @IBAction func evenNumberPressed(sender: UIButton) {
        let yeahUpPath = Bundle.main.path(forResource: "yeahUp", ofType: "wav")
        let yeahUpSoundURL = URL(fileURLWithPath: yeahUpPath!)
        if (evenNumbersPressed != nil) {
            do {
                try buttonSound = AVAudioPlayer(contentsOf: yeahUpSoundURL)
                buttonSound.prepareToPlay()
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        playSound()
    }
    
    @IBAction func oddNumberPressed(sender: UIButton) {
        let yeahDownPath = Bundle.main.path(forResource: "yeahDown", ofType: "wav")
        let yeahDownSoundURL = URL(fileURLWithPath: yeahDownPath!)

        if (oddNumbersPressed != nil) {
            do {
                try buttonSound = AVAudioPlayer(contentsOf: yeahDownSoundURL)
                buttonSound.prepareToPlay()
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        playSound()
    }
    
    @IBAction func zeroPressed(sender: UIButton) {
        let yeahPath = Bundle.main.path(forResource: "yeah", ofType: "wav")
        let yeahSoundURL = URL(fileURLWithPath: yeahPath!)

        if (zeroIsPressed != nil) {
            do {
                try buttonSound = AVAudioPlayer(contentsOf: yeahSoundURL)
                buttonSound.prepareToPlay()
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        playSound()
    }
    
    func playSound() {
        if buttonSound.isPlaying {
            buttonSound.stop()
        }
        buttonSound.play()
    }
    
}
