//
//  ViewController.swift
//  PartyRockMansionTableViews
//
//  Created by Joseph Park on 11/22/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var partyRocks = [PartyRock]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hardcoded video url
        let p1 = PartyRock(imageURL: "https://i.ytimg.com/vi/ev4bY1SkZLg/hqdefault.jpg?custom=true&w=336&h=188&stc=true&jpg444=true&jpgq=90&sp=68&sigh=2eQIiU3s4BGW4Q7oDtui_k5Ketc", videoURL: "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/ev4bY1SkZLg\" frameborder=\"0\" allowfullscreen></iframe>", videoTitle: "Let's Get Ridiculous")
        
        
        let p2 = PartyRock(imageURL: "https://i.ytimg.com/vi/ev4bY1SkZLg/hqdefault.jpg?custom=true&w=336&h=188&stc=true&jpg444=true&jpgq=90&sp=68&sigh=2eQIiU3s4BGW4Q7oDtui_k5Ketc", videoURL: "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/ev4bY1SkZLg\" frameborder=\"0\" allowfullscreen></iframe>", videoTitle: "New Thang")
        
         let p3 = PartyRock(imageURL: "https://i.ytimg.com/vi/ev4bY1SkZLg/hqdefault.jpg?custom=true&w=336&h=188&stc=true&jpg444=true&jpgq=90&sp=68&sigh=2eQIiU3s4BGW4Q7oDtui_k5Ketc", videoURL: "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/ev4bY1SkZLg\" frameborder=\"0\" allowfullscreen></iframe>", videoTitle: "Shots")
        
        let p4 = PartyRock(imageURL: "https://i.ytimg.com/vi/ev4bY1SkZLg/hqdefault.jpg?custom=true&w=336&h=188&stc=true&jpg444=true&jpgq=90&sp=68&sigh=2eQIiU3s4BGW4Q7oDtui_k5Ketc", videoURL: "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/ev4bY1SkZLg\" frameborder=\"0\" allowfullscreen></iframe>", videoTitle: "Light's Out")
        
        partyRocks.append(p1)
        partyRocks.append(p2)
        partyRocks.append(p3)
        partyRocks.append(p4)

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PartyCell", for: indexPath) as? PartyCell {
            
            let partyRock = partyRocks[indexPath.row]
            cell.updateUI(partyRock: partyRock)
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partyRocks.count
        
    }
    
    
}
