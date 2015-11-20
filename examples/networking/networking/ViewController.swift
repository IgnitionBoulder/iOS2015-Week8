//
//  ViewController.swift
//  networking
//
//  Created by Eric Reid on 11/19/15.
//  Copyright © 2015 Spark Boulder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = ""
        imageView.image = nil
    }

    @IBAction func update(sender: AnyObject) {
        nameLabel.text = ""
        imageView.image = nil
        guard let username = usernameField.text where !username.isEmpty else {
            let alert = UIAlertController(title: nil, message: "Please enter a username", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        let urlString = "https://api.github.com/users/\(username)"
        let request = NSURLRequest(URL: NSURL(string: urlString)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                } else if response is NSHTTPURLResponse {
                    let httpResponse = response as! NSHTTPURLResponse
                    if httpResponse.statusCode == 404 {
                        let alert = UIAlertController(title: "Error", message: "User not found", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                    }

                    if let data = data {
                        self.processResponse(data)
                    }
                }
            })

        }
        task.resume()

    }

    func processResponse(data: NSData) {
        let anyObj: AnyObject?
        do {
            anyObj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
        } catch let error as NSError {
            print("JSON Error: \(error.localizedDescription)")
            anyObj = nil
        }

        if let dict = anyObj as? [String: AnyObject] {
            let name = dict["name"] as? String ?? "(no name)"
            nameLabel.text = name

            if let avatarURL = dict["avatar_url"] as? String {
                loadAvatar(avatarURL)
            }
        }
    }

    func loadAvatar(avatarURL: String) {

        let imageDownloadTask = NSURLSession.sharedSession().downloadTaskWithURL(NSURL(string: avatarURL)!) { (location, response, error) -> Void in
            guard let location = location else {
                return
            }
            if let data = NSData(contentsOfURL: location), let image = UIImage(data: data) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.imageView.image = image
                })
            }
        }

        imageDownloadTask.resume()
    }
}