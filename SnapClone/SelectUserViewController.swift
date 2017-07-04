//
//  SelectUserViewController.swift
//  SnapClone
//
//  Created by Jack Howard on 7/4/17.
//  Copyright © 2017 JackHowa. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SelectUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var users : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // using delegate to reference the table view outlet
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // call the database of firebase
        // listen for db changes at a particular place or index
        // tell us about any childadded
        // want to know all of the new users that are added
        
        // child users is the header in the storage
        Database.database().reference().child("users").observe(DataEventType.childAdded, with: {(snapshot) in
            // returns object of each user 
            // called for each user
            print(snapshot)
            
            // like calling new
            let user = User()
            
            // setting the values
            // forcing the value as well as the upcast to a string
            
            // need to cast snapshot.value as a NSDictionary.
            let value = snapshot.value as? NSDictionary
            
            user.email = value?["email"] as! String
            
            // snapshot dictionary doesn't have a key so can keep this
            user.uid = snapshot.key // assigns the uid
            
            // kind of like shovelling back into users
            self.users.append(user)
            
            self.tableView.reloadData()
        })
    }

    // add firebase users 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // how many rows
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        // calling the cell at the index
        let user = users[indexPath.row]
        
        // assign the label of text
        cell.textLabel?.text = user.email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // find user that was selected
        let user = users[indexPath.row]
        
        // child by auto id is a firebase function that prevents reuse of id and makes unique
        Database.database().reference().child("users").child(user.uid).child("messages").childByAutoId().setValue("testing_spot")
    }
}
