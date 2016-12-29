//
//  Taco.swift
//  POPExp
//
//  Created by Joseph Park on 12/28/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import Foundation


/* An enumeration defines a common type for a group of related values and enables you to work with those values in a type-safe way within your code */

enum TacoShell: Int {
    case Flour = 1
    case Corn = 2
}

enum TacoProtein: String {
    case Beef = "Beef"
    case Chicken = "Chicken"
    case Brisket = "Brisket"
    case Fish = "Fish"
}

enum TacoCondiment: Int {
    case Loaded = 1
    case Plain = 2
    
}

//in order to create a taco, tacos must have these properties, otherwise you won't be able to initialize a taco
struct Taco {
    private var _productID: Int!
    private var _productName: String!
    private var _shellID: TacoShell!
    private var _proteinID: TacoProtein!
    private var _condimentID: TacoCondiment!
    
    //accessors form
    var productID: Int {
        return _productID
    }
    var productName: String {
        return _productName
    }
    var shellID: TacoShell {
        return _shellID
    }
    var proteinID: TacoProtein {
        return _proteinID
    }
    var condimentID: TacoCondiment {
        return _condimentID
    }
    
    /* structs don't necessarily need initializers but we'll make one for checks */
    init(productID: Int, productName: String, shellID: Int, proteinID: Int, condimentID: Int) {
        self._productID = productID
        self._productName = productName
        
        //Taco Shell
        switch shellID {
        case 2:
            self._shellID = TacoShell.Corn
        default:
            self._shellID = TacoShell.Flour
        }
        
        //Taco Protein
        switch proteinID {
        case 2:
            self._proteinID = TacoProtein.Chicken
        case 3:
            self._proteinID = TacoProtein.Brisket
        case 4:
            self._proteinID = TacoProtein.Fish
        default:
            self._proteinID = TacoProtein.Beef
        }
        
        //Taco Condiment
        switch condimentID {
        case 2:
            self._condimentID = TacoCondiment.Plain
        default:
            self._condimentID = TacoCondiment.Loaded
        }
    }
}
