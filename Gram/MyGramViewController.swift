//
//  MyGramViewController.swift
//  Gram
//
//  Created by Sumedha Mehta on 6/20/16.
//  Copyright © 2016 Sumedha Mehta. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class MyGramViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var setPicButton: UIButton!
    
    var postObjects:  [PFObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 45;
        profileImage.layer.masksToBounds = true
        setPicButton.layer.cornerRadius = 45;
        setPicButton.layer.masksToBounds = true
        collectionView.dataSource = self
        collectionView.delegate = self
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        getQuery(20)
        profileNameLabel.text = PFUser.currentUser()?.username
        var instagramPP: PFObject! {
            didSet {
                if (instagramPP["ProfilePic"] as? PFFile) != nil {
                    profileImage.file = instagramPP["ProfilePic"] as?PFFile
                    profileImage.loadInBackground()
                    setPicButton.backgroundColor = UIColor.clearColor()
                }
            }
        }
        instagramPP = PFUser.currentUser()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postObjects.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("myPostCell", forIndexPath: indexPath) as! MyPersonalCollectionViewCell
        let image = postObjects[indexPath.row]
        let caption = postObjects[indexPath.row]["caption"]
        let user = postObjects[indexPath.row]["author"]
        let username = user.username
        var instagramPost: PFObject! {
            didSet {
                cell.myImage.file = instagramPost["media"] as? PFFile
                cell.myImage.loadInBackground()
            }
        }
        instagramPost = image
        
        return cell
        
    }
    
    @IBAction func onTapImage(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        
        let choosePicture = UIAlertAction(title: "Choose Picture From Album", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("choosePic")
            let vc = UIImagePickerController()
            vc.delegate  = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(vc, animated: true, completion: nil)
            
        })
        let takePicture = UIAlertAction(title: "Take Picture", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("takePic")
            let vc1 = UIImagePickerController()
            vc1.delegate  = self
            vc1.allowsEditing = true
            vc1.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(vc1, animated: true, completion: nil)

        })
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(choosePicture)
        optionMenu.addAction(takePicture)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func getQuery(limit: Int) {
        let query = PFQuery(className:"Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        print("WHY")
        query.whereKey("author", equalTo: PFUser.currentUser()!)
        query.limit = limit
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.postObjects = objects
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.collectionView.reloadData()
        }
    }
    
    func onTimer() {
        getQuery(20)
        self.collectionView.reloadData()
    }
    
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        profileImage.image = editedImage
        let user = PFUser.currentUser()
        let imagePFFile = Post.getPFFileFromImage(editedImage)
        user!["ProfilePic"] = imagePFFile
        user!.saveInBackground()
        
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
        if(profileImage.image != nil) {
            setPicButton.backgroundColor = UIColor.clearColor()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PersonalPicsDetailViewController
        let indexPath = collectionView.indexPathForCell(sender as! UICollectionViewCell)
        vc.Post = postObjects[indexPath!.row]
        print(vc.Post)
        
        
    }
    
    
    
    
    
    
    
    
}




