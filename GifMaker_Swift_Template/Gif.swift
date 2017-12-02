//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Arturo Reyes on 11/18/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

public class Gif: NSObject, NSCoding {
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
    
    public required init?(coder aDecoder: NSCoder) {
        self.url = aDecoder.decodeObject(forKey: "url") as? NSURL
        self.videoURL = aDecoder.decodeObject(forKey: "videoURL") as? NSURL
        self.caption = aDecoder.decodeObject(forKey: "caption") as? String
        self.gifImage = aDecoder.decodeObject(forKey: "gifImage") as? UIImage
        self.gifData = aDecoder.decodeObject(forKey: "gifData") as? NSData
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.videoURL, forKey: "videoURL")
        aCoder.encode(self.caption, forKey: "caption")
        aCoder.encode(self.gifImage, forKey: "gifImage")
        aCoder.encode(self.gifData, forKey: "gifData")
    }
    
}
