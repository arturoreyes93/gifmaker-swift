//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Arturo Reyes on 11/18/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class Gif {
    let url: NSURL?
    let videoURL: NSURL?
    var caption: String?
    let gifImage: UIImage?
    var gifData: NSData?
    
    init(url:NSURL, videoURL: NSURL, caption: String?) {
        
        self.url = url
        self.videoURL = videoURL
        self.caption = caption
        self.gifImage = UIImage.gif(url: url.absoluteString!)!
        self.gifData = nil
    }
    
    init(name: String) {
        self.gifImage = UIImage.gif(name: name)
        self.url = nil
        self.videoURL = nil
        self.caption = nil
        self.gifData = nil
    }
}
