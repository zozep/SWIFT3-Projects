//
//  DataService.swift
//  POPExp
//
//  Created by Joseph Park on 12/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import Foundation

protocol DataServiceDelegate: class {
    func tacoDataLoaded()
}


//using class because this is going to be a singleton
class DataService {
    static let instance = DataService()
    
    weak var delegate: DataServiceDelegate?
    
    
    var tacoArray: Array<Taco> = []
    
    func loadTacoData() {
        // Chicken Tacos
        tacoArray.append(Taco(productID: 1, productName: "Loaded Flour Chicken Taco", shellID: 1, proteinID: 2, condimentID: 1))
        tacoArray.append(Taco(productID: 2, productName: "Loaded Corn Chicken Taco", shellID: 2, proteinID: 2, condimentID: 1))
        tacoArray.append(Taco(productID: 3, productName: "Plain Flour Chicken Taco", shellID: 1, proteinID: 2, condimentID: 2))
        tacoArray.append(Taco(productID: 4, productName: "Plain Corn Chicken Taco", shellID: 2, proteinID: 2, condimentID: 2))
        
        // Beef Tacos
        tacoArray.append(Taco(productID: 5, productName: "Loaded Flour Beef Taco", shellID: 1, proteinID: 1, condimentID: 1))
        tacoArray.append(Taco(productID: 6, productName: "Loaded Corn Beef Taco", shellID: 2, proteinID: 1, condimentID: 1))
        tacoArray.append(Taco(productID: 7, productName: "Plain Flour Beef Taco", shellID: 1, proteinID: 1, condimentID: 2))
        tacoArray.append(Taco(productID: 8, productName: "Plain Corn Beef Taco", shellID: 2, proteinID: 1, condimentID: 2))
        
        // Brisket Tacos
        tacoArray.append(Taco(productID: 9, productName: "Loaded Flour Brisket Taco", shellID: 1, proteinID: 3, condimentID: 1))
        tacoArray.append(Taco(productID: 10, productName: "Loaded Corn Brisket Taco", shellID: 2, proteinID: 3, condimentID: 1))
        tacoArray.append(Taco(productID: 11, productName: "Plain Flour Brisket Taco", shellID: 1, proteinID: 3, condimentID: 2))
        tacoArray.append(Taco(productID: 12, productName: "Plain Corn Brisket Taco", shellID: 2, proteinID: 3, condimentID: 2))
        
        // Fish Tacos
        tacoArray.append(Taco(productID: 13, productName: "Loaded Flour Fish Taco", shellID: 1, proteinID: 4, condimentID: 1))
        tacoArray.append(Taco(productID: 14, productName: "Loaded Corn Fish Taco", shellID: 2, proteinID: 4, condimentID: 1))
        tacoArray.append(Taco(productID: 15, productName: "Plain Flour Fish Taco", shellID: 1, proteinID: 4, condimentID: 2))
        tacoArray.append(Taco(productID: 16, productName: "Plain Corn Fish Taco", shellID: 2, proteinID: 4, condimentID: 2))
        
        delegate?.tacoDataLoaded()
    }
}
