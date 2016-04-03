//
//  DetailViewController.swift
//  MemeApp
//
//  Created by Antonio Sejas on 27/3/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var img: UIImageView!
    var instagramImage = InstagramImage(imgLow: UIImage(),img: UIImage())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img.image = instagramImage.img
    }
    
    //MARK: Gestures
    //From delegate
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    @IBAction func actionGesturePinch(sender: UIPinchGestureRecognizer) {
        print("actionGesturePinch",sender)
        if let view = sender.view {
            view.transform = CGAffineTransformScale(view.transform,
                                                    sender.scale, sender.scale)
            sender.scale = 1
        }
    }
    @IBAction func actionGestureRotate(sender : UIRotationGestureRecognizer) {
        print("actionGestureRotate",sender)
        if let view = sender.view {
            view.transform = CGAffineTransformRotate(view.transform, sender.rotation)
            sender.rotation = 0
        }
    }
    
}
