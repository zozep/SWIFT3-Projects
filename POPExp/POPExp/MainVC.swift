//
//  MainVC.swift
//  POPExp
//
//  Created by Joseph Park on 12/28/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    @IBOutlet weak var headerView: HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addDropShadow()
    }

  

}
