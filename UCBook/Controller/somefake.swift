//
//  ChatVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/11/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//
 /*
import Foundation
import Firebase
import UserNotifications
// data source requires two func cell row and cell
class someFake: UIViewController, UITableViewDelegate ,UITableViewDataSource {
 
    @IBOutlet weak var messageTableView: UITableView!
    
    var curUser = Auth.auth().currentUser
    
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    //identitifier found in custom xib file table cell description  nib name is name of xibfile
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell",for: indexPath) as! MessageCell
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.message.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.message.numberOfLines = 0
        let messageList = ["first Message","second sadasdasdasdaasdadasdadasdadasdadasasdada one  wrap btc  Message","third message"]
        cell.message.text = messageList[indexPath.row]
        cell.timeStamp.text = messageList[indexPath.row]
        cell.backgroundColor = UIColor(white: 114/255, alpha: 1)
        
        return cell
    }
    // resize constraints for long messages sent by users
    func setTableProperties(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // sets the current controller as the source and delegate
        messageTableView.delegate = self
        messageTableView.dataSource = self
        //identifier located in message cell xib
        //register the custom message cill bundle nil auto locate file
        messageTableView.reloadData()
        messageTableView.register(UINib(nibName:"MessageCell",bundle:nil), forCellReuseIdentifier: "messageCell")
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 140
        
    }
    
    
    
    @IBAction func sendText(_ sender: Any) {
        
        
    }
    
    
}

*/
