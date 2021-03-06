//
//  MusicListVC.swift
//  SwappingScreens
//
//  Created by Joseph Park on 11/14/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

class MusicListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        
    }

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func load3rdScreenPressed(_ sender: Any) {
        let songTitle = "YEAH"
        performSegue(withIdentifier: "PlaySongVC", sender: songTitle)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            PlaySongVC {
            if let song = sender as? String {
                    destination.selectedSong = song
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
