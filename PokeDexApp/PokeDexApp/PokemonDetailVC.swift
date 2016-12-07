//
//  PokemonDetailVC.swift
//  PokeDexApp
//
//  Created by Joseph Park on 12/5/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    //variable for pokemonlist (whether filtered or not) to be sent into
    var pokemon: Pokemon!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    
    @IBOutlet weak var evoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = pokemon.name
        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
