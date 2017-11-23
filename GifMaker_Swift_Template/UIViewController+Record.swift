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

let frameCount = 16
let delayTime: Float = 0.2
let loopCount = 0 // 0 means loop forever
extension UIViewController : UIImagePickerControllerDelegate {
    
    @IBAction func launchCamera(sender: AnyObject) {
        
        let recordVideoController = UIImagePickerController()
        recordVideoController.sourceType = UIImagePickerControllerSourceType.camera
        recordVideoController.mediaTypes = [kUTTypeMovie as String]
        recordVideoController.allowsEditing = true
        recordVideoController.delegate = self
        
        present(recordVideoController, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == kUTTypeMovie as String {
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            convertVideoToGIF(videoURL: videoURL)
            UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path!, nil, nil, nil)
            dismiss(animated: true, completion: nil)
            
            
            
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //GIF conversion methods
    func convertVideoToGIF(videoURL: NSURL) {
        let regift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        let gifURL = regift.createGif()
        displayGIF(url: gifURL!)
    }
    
    func displayGIF(url: NSURL) {
        
        let gifEditorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
        gifEditorVC.gifURL = url
        navigationController?.pushViewController(gifEditorVC, animated: true)
        
    }
    
}

extension UIViewController: UINavigationControllerDelegate {
    
}
