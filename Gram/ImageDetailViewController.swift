//
//  ImageDetailViewController.swift
//  Gram
//
//  Created by Sumedha Mehta on 6/23/16.
//  Copyright © 2016 Sumedha Mehta. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ImageDetailViewController: UIViewController {
    @IBOutlet weak var postImage: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeNumberLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var personalPic: PFImageView!
    
    
    var nameText: String?
    var captionText: String?
    var likeCount: Int?
    var postThing: PFObject?
    var dateText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nameText
        captionLabel.text = captionText
        likeNumberLabel.text = String(likeCount!)
        dateLabel.text = dateText
        var instagramPost: PFObject! {
            didSet {
                postImage.file = instagramPost["media"] as? PFFile
                postImage.loadInBackground()
            }
        }
        
        instagramPost = postThing
        var instagramPP: PFObject! {
            didSet {
                if (instagramPP["ProfilePic"] as? PFFile) != nil {
                    personalPic.file = instagramPP["ProfilePic"] as?PFFile
                    personalPic.loadInBackground()
                }
                else {
                    personalPic.image = UIImage(named: "Image-5")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
