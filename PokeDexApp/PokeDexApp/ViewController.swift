//
//  ViewController.swift
//  PokeDexApp
//
//  Created by Joseph Park on 12/4/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    var musicPlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        parsePokemonCSV()
        initAudio()
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    //play music!
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 /*loops continuously */
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    
    
    func parsePokemonCSV() {
        //creating a path to pokemon.csv file
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        //parse SCV rows, might throw an error
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            //go through each row, get the id & name from the CSV
            for row in rows {
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                
                //create pokemon object, pass that into Pokemon array (made on line 17)
                let poke = Pokemon(name: name, pokedexID: pokeID)
                pokemon.append(poke)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    //only load however many cells are going to be displayed at time
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            
            //inSearchMode
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
                
            } else {
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            return cell           /* gets to PokeCell on View */
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    //when cell's tapped whatever code i put in here will be executed
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //segueway
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke) /*poke from above*/
    }
    
    
    //sets the number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemon.count
        }
        
        return pokemon.count
    }
    
    //nubmer of sections in each collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //helps to define the size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    //searchbar boilerplate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //if there is nothing on the search bar, or if the text is deleted, revert back to original list
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
            
        } else {
            inSearchMode = true
            
            /* If pokemon name is within the searchbar, display those pokemons only
             
             1. $0 = Place holder for any and all of the objects in the original pokemon array
             2. Each pokemon object - which is a place holder for $0 in that array, we are taking the name value of that
             and checking to see if what users put in the search bar is contained inside of that name,
             4. and if it is, put that into the filtred pokemon array  */
            
            let userInputSearchBarTextLowercase = searchBar.text!.lowercased()
            filteredPokemon = pokemon.filter({$0.name.range(of: userInputSearchBarTextLowercase) != nil})
            collection.reloadData()
    
        }
    }
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    //prep for segueway, send Any
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                //if poke is the sender, and is of Class Pokemon
                if let poke = sender as? Pokemon {
                    //pokemon variable created in detailsVC, set it to main contoller's variable poke
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
}

