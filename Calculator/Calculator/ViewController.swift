//
//  ViewController.swift
//  Calculator
//
//  Created by Joseph Park on 11/15/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit
import AVFoundation


public class ViewController: UIViewController {
    var buttonSound: AVAudioPlayer!
    var runningNumber = ""
    var currentOperation = Operation.Empty
    var leftValueString = ""
    var rightValueString = ""
    var result = ""
    
    @IBOutlet var evenNumbersPressed: [UIButton]!
    @IBOutlet var oddNumbersPressed: [UIButton]!
    @IBOutlet weak var zeroIsPressed: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    

    //calculte logic
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Add = "+"
        case Subtract = "-"
        case Empty = "Empty"
        
    }
    
    @IBAction func onDividePressed (sender: AnyObject) {
        processOperation(operation:.Divide)
    }
    @IBAction func onMultiplyPressed (sender: AnyObject) {
        processOperation(operation:.Multiply)
    }
    @IBAction func onAddPressed (sender: AnyObject) {
        processOperation(operation:.Add)
    }
    @IBAction func onSubtractPressed (sender: AnyObject) {
        processOperation(operation:.Subtract)
    }
    @IBAction func onEqualsPressed(sender: AnyObject) {
        processOperation(operation: currentOperation)
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        runningNumber += "\(sender.tag)"
        outputLabel.text = runningNumber
    }
    
    func processOperation(operation: Operation) {
        
        if currentOperation != Operation.Empty {
            
            //when user selects an operator, then selects another operator without first entering a number
            if runningNumber != "" {
                rightValueString = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValueString)! * Double(rightValueString)!)"
                }
                else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValueString)! / Double(rightValueString)!)"
                }
                else if currentOperation == Operation.Add {
                    result = "\(Double(leftValueString)! + Double(rightValueString)!)"
                }
                else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValueString)! - Double(rightValueString)!)"
                }
                leftValueString = result
                outputLabel.text = result
            }
            currentOperation = operation
        }
        else {
            //First time an operator has been pressed
            leftValueString = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }

    
    
    
    
    
    
    
    
    
    
    //music play logic
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
