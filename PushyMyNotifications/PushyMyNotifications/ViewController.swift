//
//  ViewController.swift
//  PushyMyNotifications
//
//  Created by Joseph Park on 12/30/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseInstanceID

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
    
    }


}

