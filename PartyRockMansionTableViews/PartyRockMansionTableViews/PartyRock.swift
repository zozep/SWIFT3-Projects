//
//  PartyRock.swift
//  PartyRockMansionTableViews
//
//  Created by Joseph Park on 11/22/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import Foundation

class PartyRock {
    private var _imageURL: String!
    private var _videoURL: String!
    private var _videoTitle: String!
    
    //keeps outside class from manipulating data
    var imageURL: String { return _imageURL }
    var videoURL: String { return _videoURL }
    var videoTitle: String { return _videoTitle }
    
    init(imageURL: String, videoURL: String, videoTitle: String) {
        _imageURL = imageURL
        _videoURL = videoURL
        _videoTitle = videoTitle
    }
    
    
}
