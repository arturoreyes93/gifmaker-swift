//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by Arturo Reyes on 11/16/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

extension UIViewController {
    
    @IBAction func launchVideoCamera(sender: AnyObject) {
        
    }
    
    func pickercontrollerWithSource(_ source: UIImagePickerControllerSourceType) {
        
        let picker = UIImagePickerController()
        picker.sourceType = source
        pricker.mediaTypes
    }
}

