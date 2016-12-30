//
//  CircleButton.swift
//  SpeechRecognizer
//
//  Created by Joseph Park on 12/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

@IBDesignable
class CircleButton: UIButton {
    
    //edits the corner radius of the play button
    @IBInspectable var cornerRadius: CGFloat = 35.0 {
        didSet {
            setupView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = cornerRadius
    }
}
