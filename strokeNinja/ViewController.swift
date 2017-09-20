//
//  ViewController.swift
//  strokeNinja
//
//  Created by Toro Roan on 9/19/17.
//  Copyright © 2017 Toro Roan. All rights reserved.
//

import UIKit

import FacebookLogin
import FBSDKLoginKit



class ViewController: UIViewController {

    var dict : [String : AnyObject]!
    
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    //print(result!)
                    //print(self.dict)
                    
                    //create user if user does not exist
                    
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login"{
            let startGame = segue.destination as! StartGameViewController
            startGame.name = dict["name"] as? String
        }
    }
}

