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
        
        //1. REQUEST PERMISSION
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
            
            if granted {
                print("Notification Access granted")
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    //2. SCHEDULE NOTIFICATION

    @IBAction func notifyButtonTapped(sender: UIButton) {
        scheduleNotification(inSeconds: 3, completion: { success in
            if success {
                print("Successfully scheduled notification!")
            } else {
                print("Error while scheduling notification")
            }
        })
    }
    
    func scheduleNotification(inSeconds: TimeInterval, completion: @escaping (_ Sucess: Bool) -> ()) {
        
        //Add attachment
        let myImage = "testImg"
        guard let imageURL = Bundle.main.url(forResource: myImage, withExtension: "png") else {
            completion(true)
            return
        }
        
        var attachment: UNNotificationAttachment
        attachment = try! UNNotificationAttachment(identifier: "myNotification", url: imageURL, options: .none)
        
        let notification = UNMutableNotificationContent()
        
        //ONLY FOR EXTENSION
        notification.categoryIdentifier = "myNotificationCategory"
        
        //3. CREATE NOTIFICATION
        notification.title = "New Notification"
        notification.subtitle = "New subtitle"
        notification.body = "The new notification options in iOS 10!!"
        
        notification.attachments = [attachment]
        
        
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

