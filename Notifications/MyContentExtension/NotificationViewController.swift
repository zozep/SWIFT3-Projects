//
//  NotificationViewController.swift
//  MyContentExtension
//
//  Created by Joseph Park on 12/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        
        //taking the first notification out and assignminng new constant attachment to it
        guard let attachment = notification.request.content.attachments.first else {
            return
        }
        //because notification can operates outside of sandbox (when app is closed)
        if attachment.url.startAccessingSecurityScopedResource() {
            
            let imageDataFromAttachmentURL = try? Data.init(contentsOf: attachment.url)
            if let imgData = imageDataFromAttachmentURL {
                imageView.image = UIImage(data: imgData)
            }
        }
    }

}
