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

extension UIViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func launchVideoCamera(sender: AnyObject) {
        
        self.present(pickercontrollerWithSource(UIImagePickerControllerSourceTypeCamera), animated: true, completion: nil)
    }
    
    func pickercontrollerWithSource(_ source: UIImagePickerControllerSourceType) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = source
        pricker.mediaTypes = [kUTTypeMovie as String]
        picker.allowsEditing = false
        picker.delegate = self
        
        return picker
    }
    
    public func imagePickerController(picker: UIImagePickerController)
}

