//
//  NibLoadableView.swift
//  POPExp
//
//  Created by Joseph Park on 12/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

protocol NibLoadableView: class {}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
