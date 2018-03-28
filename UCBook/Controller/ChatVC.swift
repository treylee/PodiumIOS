//
//  ChatVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 3/25/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UICollectionViewController , UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    //closure statement init a global variable
    //lazy var gives access to self
    lazy var inputTextField: UITextField = {
        let text = UITextField()
        text.placeholder = " Enter message..."
        text.translatesAutoresizingMaskIntoConstraints = false
        text.delegate = self
        return text
    }()
    let cellID = "cellID"
    var messages =  [Message]()
    var friendID:String = ""
    var chatFriend = Student()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title =  chatFriend.email
        collectionView?.backgroundColor = UIColor.white
        setupInputComponents()
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
      //  messageWatcher()
        observeMessages()
        print("current user " , Auth.auth().currentUser?.uid, " chatting with ", chatFriend.uid)
        
    }
    func observeMessages(){
        print("CURRENT USER ID",Auth.auth().currentUser?.uid)
        let ref = Database.database().reference().child("messages").child("user-message").child((Auth.auth().currentUser?.uid)!)
            
            ref.observe(.childAdded, with: { (snapshot) in
                print("checking snap",snapshot)
            
            })
        }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = UIColor.blue
        
        return cell
    }
    func messageWatcher() {
        let refHandle = Database.database().reference().child("messages").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
            }
        })
        
    }
        
    func  setupInputComponents() {
        let containerView = UIView()
        //containerView.backgroundColor = UIColor.red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //send button
        // system to normal gives interative feature to button
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
     
        containerView.addSubview(inputTextField)
        // adding costant pushes pixels by the constant specified
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    //    inputTextField.widthAnchor.constraint(equalToConstant: 80).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //line above button container view
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor.black
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
        
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
    @objc func handleSend() {
        var ref: DatabaseReference!
        ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toID = chatFriend.uid
        let fromID = Auth.auth().currentUser?.uid
        let timeStamp = NSDate().timeIntervalSince1970
        let values  = ["msg": inputTextField.text!,"toID" : toID , "fromID": fromID , "timeStamp":timeStamp] as [String : Any]
        //childRef.updateChildValues(values)
        
        childRef.updateChildValues(values)  { (error,ref) in
            if error != nil {
                print(error)
                return
            }
            let userMessageRef = Database.database().reference().child("userMessages").child(fromID!)
            let messageID = childRef.key
            
            let ref2 = Database.database().reference().child("userMessages").child(toID!)
            ref2.updateChildValues([messageID: 1])
            
        }
        
    }
    //complying with delegate  can press enter to send text now
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
