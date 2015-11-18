//
//  ViewController.swift
//  twitter
//
//  Created by Eric Reid on 11/17/15.
//  Copyright © 2015 Spark Boulder. All rights reserved.
//

import UIKit
import STTwitter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tweet(sender: AnyObject) {
        let api = STTwitterAPI.twitterAPIOSWithFirstAccount()
//        api.verifyCredentialsWithUserSuccessBlock({ (userName:String!, userID:String!) -> Void in
//                print(userName)
//            }) { (error:NSError!) -> Void in
//                print(error)
//        }

//        api.postStatusUpdate("This is a tweet", inReplyToStatusID: "", latitude: "", longitude: "", placeID: "", displayCoordinates: 0, trimUser: 0, successBlock: { (result:[NSObject : AnyObject]!) -> Void in
//                print(result)
//            }) { (error:NSError!) -> Void in
//                print(error)
//        }

        api.getHomeTimelineSinceID("", count: 20, successBlock: { (statuses:[AnyObject]!) -> Void in
                print(statuses)
            }) { (error:NSError!) -> Void in
                print(error)
        }

    }

}

