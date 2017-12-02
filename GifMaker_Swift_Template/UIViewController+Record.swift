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
import AVFoundation
import Photos

extension UIViewController : UIImagePickerControllerDelegate {
    
    static let frameCount = 16
    static let delayTime: Float = 0.2
    static let loopCount = 0 // 0 means loop forever
    static let frameRate = 15
    
    @IBAction func presentVideoOptions(sender: AnyObject) {
        if !(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            checkPermission()
            launchPhotoLibrary()
        
        } else {
            let newGifActionSheet: UIAlertController = UIAlertController(title: "Create New Gif", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let recordVideo: UIAlertAction = UIAlertAction(title: "Record Video", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.launchCamera()
            })
            let chooseFromExisting = UIAlertAction(title: "Choose from Existing" , style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.checkPermission()
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
            
            // Get start and end points from trimmed video
            let start = info["_UIImagePickerControllerVideoEditingStart"] as? NSNumber
            let end = info["_UIImagePickerControllerVideoEditingEnd"] as? NSNumber
            var duration: NSNumber?
            
            DispatchQueue.main.async {
                if let start = start {
                    duration = NSNumber(value: (end!.floatValue) - (start.floatValue))
                    self.cropVideoToSquare(rawVideoURL: videoURL, start: Float(start), duration: Float(duration!))
                } else {
                    duration = nil
                    self.cropVideoToSquare(rawVideoURL: videoURL)
                    
                }
            }
            
            
            //UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path!, nil, nil, nil)
            dismiss(animated: true, completion: nil)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func cropVideoToSquare(rawVideoURL: NSURL, start: Float? = nil, duration: Float? = nil) {
        
        // Create the AVAsset and AVAssetTrack
        let videoAsset = AVAsset(url: rawVideoURL as URL)
        let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video)
        
        // Crop to square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoTrack[0].naturalSize.height, height: videoTrack[0].naturalSize.height)
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: kCMTimeZero, duration: CMTimeMakeWithSeconds(60, 30))
        
        // Rotate to portrait
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack[0])
        let t1 = CGAffineTransform(translationX: videoTrack[0].naturalSize.height, y: -(videoTrack[0].naturalSize.width - videoTrack[0].naturalSize.height)/2 )
        let t2 = t1.rotated(by: CGFloat(Float.pi/2))
        
        let finalTrasform = t2
        transformer.setTransform(finalTrasform, at: kCMTimeZero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        // Export
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.videoComposition = videoComposition
        let path = createPath()
        exporter?.outputURL = NSURL(fileURLWithPath: path as String) as URL
        exporter?.outputFileType = AVFileType.mov
        
        var croppedURL: NSURL?
        
        exporter?.exportAsynchronously {
            croppedURL = exporter?.outputURL! as! NSURL
            DispatchQueue.main.async {
                if let start = start {
                    self.convertVideoToGIF(videoURL: croppedURL!, start: start, duration: duration)
                } else {
                    self.convertVideoToGIF(videoURL: croppedURL!)
                }
            }
        }
    }
    
    func createPath() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let manager = FileManager.default
        var outputURL = documentsDirectory.appendingPathComponent("output.mov") as NSString
        do {
            try manager.createDirectory(atPath: outputURL as String, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(" Error when creating path to directory")
        }
        
        outputURL = outputURL.appendingPathComponent("output.mov") as NSString
        
        do {
            try manager.removeItem(atPath: outputURL as String)
        } catch {
            print("Error when removing output URL from File Manager")
        }
        
        return outputURL
    }
    
    //GIF conversion methods
    func convertVideoToGIF(videoURL: NSURL, start: Float? = nil, duration: Float? = nil) {
        
        let regift: Regift!
        
        if let startTime = start as Float! {
            regift = Regift(sourceFileURL: videoURL, startTime: startTime, duration: duration!, frameRate: UIViewController.frameRate)
        } else {
            regift = Regift(sourceFileURL: videoURL, frameCount: UIViewController.frameCount, delayTime: UIViewController.delayTime, loopCount: UIViewController.loopCount)
        }
        
        let gifURL = regift.createGif()
        saveGif(url: gifURL!, videoURL: videoURL)

    }
    
    func saveGif(url: NSURL, videoURL: NSURL) {
        let newGif = Gif(url: url, videoURL: videoURL, caption: nil)
        displayGIF(newGif)
    }
    
    func displayGIF(_ gif: Gif) {
        
        let gifEditorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
        gifEditorVC.gif = gif
        navigationController?.pushViewController(gifEditorVC, animated: true)
        
    }
    // csource: https://stackoverflow.com/questions/44465904/photopicker-discovery-error-error-domain-pluginkit-code-13
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
}

extension UIViewController: UINavigationControllerDelegate {
    
}
