//
//  ViewController.swift
//  PokeDexApp
//
//  Created by Joseph Park on 12/4/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        
    }
    
    //only load however many cells are going to be displayed at time
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let pokemon = Pokemon(name: "Pokemon", pokedexID: indexPath.row)
            
            cell.configureCell(pokemon: pokemon)
            
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    //when cell's tapped whatever code i put in here will be executed
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    
    //sets the number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    //nubmer of sections in each collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //helps to define the size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    
    
}

