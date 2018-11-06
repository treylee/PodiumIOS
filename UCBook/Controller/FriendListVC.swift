//
//  FriendListVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 3/26/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
import Firebase
//controls new messsages
class FriendListVC : UITableViewController {
    
    var students = [Student]()
    var rooms = [ChatRoom] ()
    var messages = [Message]()
    var messageDictionary = [String: Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        retrieveMessages()
        populateUserList()
        tableView.separatorStyle = .singleLine
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.tableView.reloadData()

    }
    func retrieveMessages() {
        
        let refHandle = Database.database().reference().child("messages").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.setValuesForKeys(dictionary)
               // self.messages.append(message)
                if let toID = message.toID {
                    self.messageDictionary[toID] = message
                    self.messages = Array(self.messageDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return (message1.timeStamp?.intValue)! > (message2.timeStamp?.intValue)!
                    })
                }
            }
        })
    }
    func populateUserList(){
        print("populating user list")
        
        Firestore.firestore().collection("chatRooms").document("users").collection((Auth.auth().currentUser?.uid)!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let room: ChatRoom = ChatRoom(dictionary: document.data())!
                        
                        self.rooms.append(room)
                        print("seller",room.sellerName)
                        
                    }
                    
                    self.tableView.reloadData()
                   // DispatchQueue.main.async {
                     //   self.tableView.reloadData()
                        
                   // }
                    print("reloading data")
                }
        }
        
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let seller = rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendListItem", for: indexPath) as! FriendListItem
       
        cell.pic.layer.masksToBounds = false
        cell.pic.layer.cornerRadius = cell.pic.frame.height/2
        cell.pic.clipsToBounds = true
        // look into other libraries that cache images like kingfisher make it quicker to appear on message screen
        
        if let profileImageUrl = seller.sellerPhoto {
            let url = NSURL(string: profileImageUrl)
            var request = URLRequest(url: url! as URL)
            URLSession.shared.dataTask(with:request) { data,response,error in
                if error != nil {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async {
                    cell.pic.image = UIImage(data:data!)
         
                
            }
            }.resume()
        }
 /*
        // another way of loading an image from firebase url
        DispatchQueue.main.async {

        let url = URL(string: student.profileImageUrl!)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if
        cell.pic.image = UIImage(data: data!)
    
        }

    */
    
        //adding gesture recognizer alternative to IBaction
        cell.pic.isUserInteractionEnabled = true
        cell.username.text = seller.sellerName
        cell.message.text = "Student"
        // removes cell seperator from bottom
        return cell

}
    var selectedCell: IndexPath = []
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("This cell from the chat list was selected: \(indexPath.row)")
        selectedCell = indexPath
        beginChatting()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    func beginChatting(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "ChatBoard", bundle: nil)
        // the identifier is the storyboardID near under the class name section
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.friendID = "Checking if Friend ID passed"
        let room = rooms[selectedCell.row]
        vc.chatFriend = room
        navigationController?.pushViewController(vc, animated: true)
    }
}
