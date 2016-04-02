//
//  DetailViewController.swift
//  MemeApp
//
//  Created by Antonio Sejas on 27/3/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    var instagramImage = InstagramImage(imgLow: UIImage(),img: UIImage())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img.image = instagramImage.img
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        // we hide tabbar
//        tabBarController?.tabBar.hidden = true
//    }
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        // we show tabbar before leave
//        tabBarController?.tabBar.hidden = false
//    }
    
}
