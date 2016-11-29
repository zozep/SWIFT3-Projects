//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Joseph Park on 11/28/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

class ItemDetailsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
    }
}
