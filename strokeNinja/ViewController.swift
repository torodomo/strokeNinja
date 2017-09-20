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
    
    var id: String?
    
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
                    
                    let url = URL(string: "http://18.220.96.49/users")!
                    let request = URLRequest(url: url)
                    let session = URLSession.shared
                    _ = session.dataTask(with: request, completionHandler: { data, response, error in

                        if let info = data {
                            // check info if the users exist
                            let jsonData = try? (JSONSerialization.jsonObject(with: info, options: .mutableContainers) as! [String:Any])
                            //print(jsonData!)
                            var name = self.dict["name"] as! String
                            name = name.replacingOccurrences(of: " ", with: "")
                            let dict = jsonData?["users"] as! [[String:Any]]
                            for user in dict{
                                let name2 = user["name"] as! String
                                if name2 == name{
                                    self.id = user["_id"] as? String
                                }
                            }
                            if self.id == nil{
                                let url = URL(string: "http://18.220.96.49/users/add/\(name)/\(name)")!
                                let request = URLRequest(url: url)
                                let session = URLSession.shared
                                _ = session.dataTask(with: request).resume()
                            }
                            
                        }
                    }).resume()
                    
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login"{
            let startGame = segue.destination as! StartGameViewController
            var name = self.dict["name"] as! String
            name = name.replacingOccurrences(of: " ", with: "")
            startGame.name = name
            startGame.id = id
        }
    }
}

