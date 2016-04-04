//
//  DetailViewController.swift
//  MemeApp
//
//  Created by Antonio Sejas on 27/3/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var stackHorizontalTags: UIStackView!
    @IBOutlet weak var stackVerticalTags: UIStackView!
    @IBOutlet weak var img: UIImageView!
    //Just for Storyboard, actually it's hidden
    @IBOutlet weak var lblTags: UILabel!
    var instagramImage = InstagramImage(imgLow: UIImage(),img: UIImage(), tags: [String]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img.image = instagramImage.img
        showTags()
    }
    //MARK: TAGS
    func showTags(){
        lblTags.hidden = true
        var stackView = stackHorizontalTags
        var size:CGFloat = 60
        let deviceWidth = self.view.bounds.size.width
        for tag in instagramImage.tags {
            let label = UILabel()
            label.textAlignment = NSTextAlignment.Center
            label.text = "#\(tag)  "
            label.sizeToFit()
            size += label.frame.width
            print("size > deviceWidth", size , deviceWidth)
            if size > deviceWidth {
                //We add new horizontal stack
                size = 60
                stackView = UIStackView()
                stackView.axis = .Horizontal
                stackView.distribution = .EqualSpacing;
                //stackView.alignment = .;
                stackView.backgroundColor = UIColor.redColor()
                stackVerticalTags.addArrangedSubview(stackView)
            }
            stackView.addArrangedSubview(label)
        }
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
