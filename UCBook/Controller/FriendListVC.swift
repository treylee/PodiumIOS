//
//  FriendListVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 3/26/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
//controls new messsages
class FriendListVC : UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    func getUserImage(){
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "friendListItem", for: indexPath) as! FriendListItem
        cell.pic.layer.borderWidth = 1
        cell.pic.layer.borderColor = UIColor.white.cgColor
        cell.pic.backgroundColor = UIColor.gray
        cell.pic.layer.masksToBounds = false
        cell.pic.layer.cornerRadius = cell.pic.frame.height/2
        cell.pic.clipsToBounds = true
        cell.pic.image = UIImage(named: "FullSizeRender")
        //adding gesture recognizer alternative to IBaction
        cell.pic.isUserInteractionEnabled = true
        cell.username.text = "Trey Lee Bae Bee"
        cell.message.text = " Some long message that I didnt feel like writing"
        // removes cell seperator from bottom
        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
        return cell

}
    var selectedCell: IndexPath = []
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("This cell from the chat list was selected: \(indexPath.row)")
        selectedCell = indexPath
        beginChatting()
    }
    func beginChatting(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "ChatBoard", bundle: nil)
        // the identifier is the storyboardID near under the class name section
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.friendID = "Checking if Friend ID passed"
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
