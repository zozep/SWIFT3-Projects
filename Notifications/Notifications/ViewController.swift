//
//  ViewController.swift
//  Notifications
//
//  Created by Joseph Park on 12/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. request permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
            
            if granted {
                print("Notification Access granted")
            } else {
                print(error!.localizedDescription)
            }
        })
    }

    @IBAction func notifyButtonTapped(sender: UIButton) {
        scheduleNotification(inSeconds: 3, completion: { success in
            if success {
                print("Successfully scheduled notification!")
            } else {
                print("Error while scheduling notofication")
            }
        })
    }
    
    func scheduleNotification(inSeconds: TimeInterval, completion: @escaping (_ Sucess: Bool) -> ()) {
        let notification = UNMutableNotificationContent()
        
        notification.title = "New Notification"
        notification.subtitle = "New subtitle"
        notification.body = "The new notification options in iOS 10!!"
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let request = UNNotificationRequest(identifier: "myNotification", content: notification, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("error")
                completion(false)
                
            } else {
                completion(true)
            }
        })
    }
}

