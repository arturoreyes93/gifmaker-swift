//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Arturo Reyes on 11/18/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class PreviewViewController: UIViewController {
    
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var gif: Gif?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gifImage = gif?.gifImage {
            gifImageView.image = gifImage
        }
    }
    
    @IBAction func shareGif(_ sender: Any) {
        let url: NSURL = (self.gif?.url)!
        let animatedGIF = NSData(contentsOf: url as URL)
        let itemsToShare = [animatedGIF]
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        navigationController?.present(activityVC, animated: true, completion: nil)
    }
    
}
