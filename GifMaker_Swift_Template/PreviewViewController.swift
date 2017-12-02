//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Arturo Reyes on 11/18/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

protocol PreviewViewControllerDelegate: class {
    //source : https://stackoverflow.com/questions/29025876/why-custom-delegate-in-ios-is-not-called
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif)
}

class PreviewViewController: UIViewController {
    
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var gif: Gif?
    var previewDelegate: PreviewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonsStyle()
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
    
    @IBAction func createAndSave(_ sender: Any) {
        previewDelegate?.previewVC(preview: self, didSaveGif: gif!)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setButtonsStyle() {
        saveButton.layer.cornerRadius = 4.0
        shareButton.layer.cornerRadius = 4.0
        shareButton.layer.borderColor = UIColor(red: 255.0/255.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0).cgColor
        shareButton.layer.borderWidth = 1.0
    }
}
