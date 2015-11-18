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

    var api: STTwitterAPI!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api = STTwitterAPI.twitterAPIOSWithFirstAccount()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func tweet(sender: AnyObject) {
        api.verifyCredentialsWithUserSuccessBlock({ (username:String!, userID:String!) -> Void in
            self.getTweets()
            }) { (error:NSError!) -> Void in
            print(error)
        }
    }

    func getTweets() {
        api.getHomeTimelineSinceID(nil, count: 20, successBlock: { (tweets:[AnyObject]!) -> Void in
            for tweet in tweets {
                let text = tweet["text"] as! String
                print(text)
            }
            }) { (error:NSError!) -> Void in
                print(error)
        }
    }
}

