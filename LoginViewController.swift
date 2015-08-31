//
//  LoginViewController.swift
//  AppLikeTinder
//
//  Created by Marko Budal on 31/08/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import UIKit
import FacebookSDK

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pressedFBLogin(sender: UIButton) {
        PFFacebookUtils.logInWithPermissions(["public_profile", "user_about_me", "user_birthday"], block: {
            user, error in
            if user == nil {
                println("Uh ho. User canceld the Facebook Login")
                return
            } else if user!.isNew {
                println("User signed up and logged in throughty Facebook!")
                
                FBRequestConnection.startWithGraphPath("/me?fields=picture,first_name,birthday,gender", completionHandler: {
                    connection, result, error in
                    var r = result as! NSDictionary

                    user!["firstName"] = r["first_name"]
                    user!["gender"] = r["gender"]
                    user!["picture"] = ((r["picture"] as! NSDictionary)["data"] as! NSDictionary)["url"]
                    
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    user!["birthday"] = dateFormatter.dateFromString(r["birthday"] as! String)
                    
                    user!.saveInBackgroundWithBlock({
                        success, error in
                            println(success)
                            println(error)
                    })
                })
                
            } else {
                println("User logged in throught Facebook!")
            }
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardNavController") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            
        })
    }
}
