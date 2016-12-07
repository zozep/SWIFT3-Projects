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
    @IBOutlet weak var evoLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = pokemon.name
        let img = UIImage(named: "\(pokemon.pokedexID)")
        mainImage.image = img
        currentEvoImage.image = img
        pokemon.downloadPokemonDetails {
            //print("did arrive here")
            //whatever we write here will only be called after the network call is completed
            self.updateUI()
        }
    }
    
    func updateUI() {
    
        
        attackLabel.text = pokemon.attack
        defenseLabel.text = pokemon.defense
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        evoLabel.text = pokemon.nextEvolutionText
        typeLabel.text = pokemon.type
        pokedexLabel.text = "\(pokemon.pokedexID)"
        descriptionLabel.text = pokemon.description
        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
