//
//  SavedGifsViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Arturo Reyes on 11/18/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class SavedGifsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIImageView!
    
    var savedGifs = [Gif]()
    let cellMargin: CGFloat = 12.0
    
    var gifsFilePath: String {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsPath = directories[0]
        let gifsPath = documentsPath.appending("/savedGifs")
        return gifsPath
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        emptyView.isHidden = (savedGifs.count != 0)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showWelcome()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let unarchivedGifs = NSKeyedUnarchiver.unarchiveObject(withFile: gifsFilePath) as? [Gif] {
            savedGifs = unarchivedGifs
        }
    }
    
    func showWelcome() {
        if !(UserDefaults.standard.bool(forKey: "WelcomeViewSeen")) {
            let welcomeVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            navigationController?.pushViewController(welcomeVC, animated: true)
        }
    }
    
    // MARK: UICollectionViewDelegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gif = savedGifs[indexPath.item]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.gif = gif
        
        detailVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(detailVC, animated: true, completion: nil)
    }
    
    
    // MARK: UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCell
        let gif = savedGifs[indexPath.item]
        cell.configureGif(gif: gif)
        return cell
    }
    
    // MARK: UICollectionViewFlowLayout Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - (cellMargin*2.0))/2.0
        let size = CGSize(width: width, height: width)
        return size
    }
    
    

}

extension SavedGifsViewController : PreviewViewControllerDelegate {
    
    // MARK: PreviewViewControllerDelegate Method
    
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif) {
        print("previewVC called")
        gif.gifData = NSData(contentsOf: gif.url! as URL)
        self.savedGifs.append(gif)
        NSKeyedArchiver.archiveRootObject(self.savedGifs, toFile: self.gifsFilePath)
    }
}

