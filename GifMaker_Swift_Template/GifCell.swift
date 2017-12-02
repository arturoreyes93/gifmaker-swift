//
//  GifCell.swift
//  GifMaker_Swift_Template
//
//  Created by Arturo Reyes on 11/18/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class GifCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    func configureGif(gif: Gif) {
        DispatchQueue.main.async {
            self.gifImageView.image = gif.gifImage
        }
        
    }
}
