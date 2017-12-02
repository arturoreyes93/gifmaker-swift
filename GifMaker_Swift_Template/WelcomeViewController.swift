//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Arturo Reyes on 11/18/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var defaultGifImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserDefaults.standard.set(true, forKey: "WelcomeViewSeen")
        let proofOfConceptGif = UIImage.gif(name: "tinaFeyHiFive")
        defaultGifImageView.image = proofOfConceptGif
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
