//
//  StartGameViewController.swift
//  strokeNinja
//
//  Created by Andrew Lau on 9/19/17.
//  Copyright © 2017 Toro Roan. All rights reserved.
//

import UIKit

class StartGameViewController: UIViewController {

    var id: Int?
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(name)
        // Do any additional setup after loading the view.
    }


    @IBAction func startGamePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "CreateGame", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateGame"{
            let nav = segue.destination as! UINavigationController
            let createGame = nav.topViewController as! CreateGameViewController
            createGame.name = name
        }
    }
}
