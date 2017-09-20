//
//  CreateGameViewController.swift
//  strokeNinja
//
//  Created by Andrew Lau on 9/19/17.
//  Copyright © 2017 Toro Roan. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var id: Int?
    var name: String?
    
    @IBOutlet weak var wordTable: UITableView!
    @IBOutlet weak var friendTable: UITableView!
    
    var word: [String] = []
    var friends: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordTable.dataSource = self
        wordTable.delegate = self
        friendTable.dataSource = self
        friendTable.delegate = self
        // Do any additional setup after loading the view.
        
        let appId = "c12578dd"
        let appKey = "ac6827501f0d471fe33e988f50cd3d9c"
//        let language = "en"
//        let filters = "domains=mammal"
        let url = URL(string: "https://od-api.oxforddictionaries.com:443/api/v1/wordlist/en/domains%3Dmammal?word_length=%3E3%3C6")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(appId, forHTTPHeaderField: "app_id")
        request.addValue(appKey, forHTTPHeaderField: "app_key")
        
        
        let session = URLSession.shared
        _ = session.dataTask(with: request, completionHandler: { data, response, error in
            //if let resp = response{
            if let info = data{
                let jsonData = try? (JSONSerialization.jsonObject(with: info, options: .mutableContainers) as! [String:Any])
                let dictionary = jsonData!["results"] as! [[String:String]]
                
                for _ in 1...3{
                    
                    let ranIndex = Int(arc4random_uniform(UInt32(dictionary.count)))
                    
                    self.word.append(dictionary[ranIndex]["word"]!)
                
                }
                self.wordTable.reloadData()
                
            }
        }).resume()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            return word.count
        }
        else {
            return friends.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)
            cell.textLabel?.text = word[indexPath.row]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
            cell.textLabel?.text = friends[indexPath.row]
            return cell
            
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "drawMisson", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "drawMisson"{
            let nav = segue.destination as! UINavigationController
            let drawPad = nav.topViewController as! drawPadViewController
            drawPad.viewDidLoad()
        }
    }
}
