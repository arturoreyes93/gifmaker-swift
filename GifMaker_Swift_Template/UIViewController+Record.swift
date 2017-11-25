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
    
    @IBAction func presentVideoOptions(sender: AnyObject) {
        if !(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
        launchPhotoLibrary()
        } else {
            let newGifActionSheet: UIAlertController = UIAlertController(title: "Create New Gif", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let recordVideo: UIAlertAction = UIAlertAction(title: "Record Video", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.launchCamera()
            })
            let chooseFromExisting = UIAlertAction(title: "Choose from Existing" , style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.launchPhotoLibrary()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            newGifActionSheet.addAction(recordVideo)
            newGifActionSheet.addAction(chooseFromExisting)
            newGifActionSheet.addAction(cancel)
            let pinkColor = UIColor(red: 255.0/255.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0)
            newGifActionSheet.view.tintColor = pinkColor
            
            present(newGifActionSheet, animated: true, completion: nil)
        }
        
    }
    
    public func launchCamera() {
        present(pickerControllerWithSource(source: UIImagePickerControllerSourceType.camera), animated: true, completion: nil)
    }
    
    public func launchPhotoLibrary() {
        present(pickerControllerWithSource(source: UIImagePickerControllerSourceType.photoLibrary), animated: true, completion: nil)
    }
    
    func pickerControllerWithSource(source: UIImagePickerControllerSourceType) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.allowsEditing = true
        picker.delegate = self
        
        return picker
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == kUTTypeMovie as String {
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            convertVideoToGIF(videoURL: videoURL)
            //UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path!, nil, nil, nil)
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
        saveGIf(url: gifURL!, videoURL: videoURL)
    }
    
    func saveGIf(url: NSURL, videoURL: NSURL) {
        let newGif = Gif(url: url, videoURL: videoURL, caption: nil)
        displayGIF(newGif)
    }
    
    func displayGIF(_ gif: Gif) {
        
        let gifEditorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
        gifEditorVC.gif = gif
        navigationController?.pushViewController(gifEditorVC, animated: true)
        
    }
    
}

extension UIViewController: UINavigationControllerDelegate {
    
}
