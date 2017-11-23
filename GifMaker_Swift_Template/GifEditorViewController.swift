//
//  GifEditorViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Arturo Reyes on 11/18/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class GifEditorViewController : UIViewController {
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var captionTExtField: UITextField!
    
    var gifURL: NSURL?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let gifURL = gifURL {
            let gifFromRecording = UIImage.gif(url: gifURL.absoluteString!)
            gifImageView.image = gifFromRecording
        }
    }
}
