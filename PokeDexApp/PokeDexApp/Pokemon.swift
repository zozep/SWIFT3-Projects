//
//  Pokemon.swift
//  PokeDexApp
//
//  Created by Joseph Park on 12/5/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _pokemonURL: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLV: String!
    
    //Getter
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
        
    var nextEvolutionLV: String {
        if _nextEvolutionLV == nil {
            _nextEvolutionLV = ""
        }
        return _nextEvolutionLV
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
        
    //Initializer
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexID)"
    }
        
    func downloadPokemonDetails (completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON { reseponse in
        if let dict = reseponse.result.value as? Dictionary<String, AnyObject> {
            if let weight = dict["weight"] as? String {
                self._weight = weight
            }
            if let height = dict["height"] as? String {
                self._height = height
            }
            if let attack = dict["attack"] as? Int {
                self._attack = "\(attack)"
            }
            if let defense = dict["defense"] as? Int {
                self._defense = "\(defense)"
            }
            if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                if let nameType = types[0]["name"] {
                    self._type = nameType.capitalized
                }
                //if poskemon has more than 1 type
                if types.count > 1 {
                    for x in 1..<types.count {
                        if let typeName = types[x]["name"] {
                            self._type! += "/\(typeName.capitalized)"
                        }
                    }
                }
            } else {
                self._type = ""
            }
            
            //description requires separate call link
            if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                if let url = descArr[1]["resource_uri"] {
                    let descURL = "\(URL_BASE)\(url)"
                    
                    Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                        if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                            if let description = descDict["description"] as? String {
                                let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                self._description = newDescription
                            }
                        }
                        completed()
                    })
                }
            } else {
                self._description = ""
            }
                //if there is an evolution
            if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    if let nextEvo = evolutions[0]["to"] as? String {
                        //excluding megas, etc that dont have assets for.
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvo
                            
                            //evolutionID and replacing api URLs
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStringURL = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoID = newStringURL.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionID = nextEvoID
                                
                                if let evoLvExists = evolutions[0]["level"] {
                                    if let level = evoLvExists as? Int {
                                        self._nextEvolutionLV = "\(level)"
                                    }
                                } else {
                                    self._nextEvolutionLV = ""
                                }
                            }
                        }
                    }
                }
            }
            completed()
        }
    }
}
