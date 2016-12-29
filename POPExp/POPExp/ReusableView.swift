//
//  ReusableView.swift
//  POPExp
//
//  Created by Joseph Park on 12/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

protocol ReusableView: class {}


//constrains to UIView
extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
