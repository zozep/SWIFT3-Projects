//
//  DropShadow.swift
//  POPExp
//
//  Created by Joseph Park on 12/28/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

protocol DropShadow {}

extension DropShadow where Self: UIView {
    func addDropShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
    }
}
