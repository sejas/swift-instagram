//
//  ViewController.swift
//  instagram
//
//  Created by Antonio Sejas on 2/4/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collection: UICollectionView!
    var images:[InstagramImage] = []
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.dataSource = self
        collection.delegate = self
        loadImages()
    }
    func loadImages(){
        let url = NSURL(string: "https://yh7xwdnrg3.execute-api.us-west-2.amazonaws.com/prod/garantino")!
        let request = NSMutableURLRequest(URL: url)
        print(request)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            // if an error occurs, print it and re-enable the UI
            func displayError(message: String) {
                 print(message,error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx! \(response)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: AnyObject!
            do {
                //BEST WAY TO PARSE JSON
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
//            print(parsedResult)
//            guard let imagesJson = parsedResult["data"] as? NSArray where imagesJson.count >= 0 else {
//                displayError("data cuantos \(parsedResult["data"])")
//                return
//            }
            if let imagesJson = parsedResult["data"] as? [[String:AnyObject]] {
                for foto in imagesJson {
                    if let thumbnail = foto["images"]!["low_resolution"] as? [String:AnyObject] {
                        if let url = thumbnail["url"] as? String {
                            let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!, completionHandler: { (data, response, error) in
                                if nil == error {
                                    let instagramImage = InstagramImage(imgLow: UIImage(data: data!)!, img: UIImage(data: data!)!)
                                    performUIUpdatesOnMain({
                                        self.images.append(instagramImage)
                                        self.collection.reloadData()
                                    })
                                }else{
                                    displayError("Error downloading image error\(error) url: \(url)")
                                }
                            })
                            task.resume()
                        }
                    }
                }
            }
        }
        task.resume()
    }
    override func viewWillAppear(animated: Bool) {
        collection.reloadData()
        //Suscribe to orientation change
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CollectionViewController.orientationChanged), name: UIDeviceOrientationDidChangeNotification, object: nil)
        initFlowLayout()
    }
    override func viewWillDisappear(animated: Bool) {
        //Unsuscribe to orientation change
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    //Set 3 cells per row
    func initFlowLayout() {
        let space:CGFloat = 5.0
        let dimension = (self.view.bounds.size.width - ( 6 * space )) / 2.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.sectionInset = UIEdgeInsets(top: space, left: space*2, bottom: space, right: space*2)
        flowLayout.itemSize = CGSizeMake(dimension, dimension*1.2)
    }
    func orientationChanged() {
        initFlowLayout()
    }
    
    
    //MARK: Collection
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.img.image = images[indexPath.row].img
        return cell
    }
    //MARK: Segues
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("toImageDetail", sender: indexPath.row)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if("toImageDetail" == segue.identifier){
            let detail = segue.destinationViewController as! DetailViewController
            detail.instagramImage = images[sender as! Int]
        }
    }

}