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
    var chatFriend = ChatRoom(dictionary: ["default" :"default"])
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.collectionView?.reloadData()

        self.tabBarItem.title = "Chat"
        navigationItem.title =  chatFriend?.sellerName
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellID)
       // messageWatcher()
        
        // 58 is a the input text area +8 pixels of padding inset locks in collectionview
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 50, right: 0)
         setupInputComponents()
        
        
    }
    
    
    @objc func handleSend(sender: UIButton) {
        print("HITBUTTON")
        
        var ref = Firestore.firestore().collection("messages")
        let toID = chatFriend?.sellerId
        let fromID = Auth.auth().currentUser?.uid
        let timeStamp = NSDate().timeIntervalSince1970
        let values  = ["msg": inputTextField.text!,"toID" : toID , "fromID": fromID , "timeStamp":timeStamp] as [String : Any]
        
        inputTextField.text = ""
        let uuid = UUID().uuidString
        let messageId = ["messageId":uuid]

        //message bucket
        let ref1 = Firestore.firestore().collection("chat").document(chatFriend?.dic!["roomId"] as! String).collection("messages").addDocument(data: values)
        //storemessage location
        /*
        let ref2 =  Firestore.firestore().collection("users").document((chatFriend?.sellerId)!).collection("messages").document((Auth.auth().currentUser?.uid)!).collection("messageId").addDocument(data: messageId)
        //store message location
        let ref3 =  Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("messages").document((chatFriend?.sellerId)!).collection("messageId").addDocument(data: messageId)
        
   */
        var newMsg = Message()
        newMsg.toID = values["toID"] as! String
        newMsg.fromID =  values["fromID"] as! String
        newMsg.timeStamp =  values["timeStamp"] as! NSNumber
        newMsg.msg = values["msg"] as! String
        print("MESSAGEE2",newMsg.msg)
        self.messages.append(newMsg)      //  self.observeMessages()
        self.collectionView?.reloadData()
        
        
        
    }
    
    
    func  setupInputComponents() {
        
        observeMessages()
        
        let containerView = UIView()
        
        containerView.backgroundColor = UIColor.white
        
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
        
        sendButton.addTarget(self, action: #selector(self.handleSend(sender:)), for: .touchUpInside)

        
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
        
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor,constant:-20).isActive = true
        
        inputTextField.layer.borderColor = UIColor.black.cgColor
        
        inputTextField.layer.borderWidth = 0.5
        
        inputTextField.layer.cornerRadius = 16
        
        inputTextField.layer.masksToBounds = true
        
        
        
        /*
         
         //line above button container view set to point if wan tto show
         
         let seperatorLineView = UIView()
         
         seperatorLineView.backgroundColor = UIColor.black
         
         seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
         
         containerView.addSubview(seperatorLineView)
         
         
         
         seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
         
         seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
         
         seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
         
         seperatorLineView.heightAnchor.constraint(equalToConstant: 0.3).isActive = true
         
         */
        
        
        
        
        
    }
    func observeMessages(){
        
        print("CURRENT USER ID",Auth.auth().currentUser?.uid)
        
        Firestore.firestore().collection("chat").document(chatFriend?.dic!["roomId"] as! String).collection("messages")
            
            .getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    
                    print("Error getting documents: \(err)")
                    
                } else {
                    var messageLocation = ""
                    for document in querySnapshot!.documents {
                        
                        let seller_book_info: [String: Any] = document.data()
                        
                        var msg = Message()
                        msg.toID = seller_book_info["toID"] as! String
                        msg.fromID =  seller_book_info["fromID"] as! String
                        msg.timeStamp =  seller_book_info["timeStamp"] as! NSNumber
                        msg.msg = seller_book_info["msg"] as! String
                        print("MESSAGEE",msg.msg)
                        self.messages.append(msg)
                    }
                    self.collectionView?.reloadData()
                    
                }}
    
        
    }

    
    
        
        override func viewDidAppear(_ animated: Bool) {
            self.collectionView?.reloadData()

            print("MESSAGES COUNT",messages.count)
            
            self.tabBarController?.tabBar.isHidden = true
            
            if messages.count > 0 {
                
                let index = IndexPath(item: (self.messages.count) - 1, section: 0)
                
                self.collectionView?.scrollToItem(at: index, at: UICollectionViewScrollPosition.bottom, animated: true)
                
            }
            
        }
        
        
        
        
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            print("msgcount",messages.count)
            return messages.count
            
        }
        
         func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            print("inheihgt")
            var height: CGFloat = 80
            
            
            
            if let text = messages[indexPath.item].msg {
                
                // add 20 to txt view  to extend the whole box
                
                height = getEstimatedTextHeight(text: text).height + 20
                
            }
            
            return CGSize(width: view.frame.width, height: height)
            
        }
        
        func getEstimatedTextHeight(text: String) ->CGRect {
            
            let size = CGSize(width: 200, height: 1000)
            
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
            
        }
        
       override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MessageCell
            
            
            
            let message = messages[indexPath.item]
            cell.textView.text = message.msg
            
            
            
            if message.fromID == Auth.auth().currentUser?.uid {
                
                cell.bubbleView.backgroundColor = MessageCell.blueColor
                
                cell.textView.textColor = UIColor.white
                
                cell.profileImageView.isHidden = true
                
                cell.bubbleRightAnchor?.isActive = true
                
                cell.bubbleLeftAnchor?.isActive = false
                
            } else{
                
                cell.bubbleView.backgroundColor = UIColor.lightGray
                
                cell.textView.textColor = UIColor.black
                
                cell.profileImageView.isHidden = false
                
                cell.bubbleRightAnchor?.isActive = false
                
                cell.bubbleLeftAnchor?.isActive = true
                
                
                
            }
            
            cell.bubbleWidthAnchor?.constant =  getEstimatedTextHeight(text: message.msg!).width + 32
            
            // load cell image
            
            // can also set to default image here instead of loading from cache
            
            if let profileImageUrl = self.chatFriend?.sellerPhoto {
                
                cell.profileImageView.loadImageUsingCache(withUrl: profileImageUrl)
                
                
                
            }
            let url = URL(string: chatFriend?.sellerPhoto as! String)
           print("chatfriend",chatFriend?.sellerPhoto)
            cell.profileImageView.kf.setImage(with: url)
            
            
            
            return cell
            
        }
        
        func messageWatcher() {
            
            let refHandle = Firestore.firestore().collection("messages").document((Auth.auth().currentUser?.uid)!).collection((chatFriend?.sellerId)!)
            
                
                
                /*
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let message = Message()
                    
                    message.setValuesForKeys(dictionary)
                    
                    self.messages.append(message)
                    
                }
                
            })
            */
            
            
        }
        
        
        
        
        
        
        //complying with delegate  can press enter to send text now
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            
            return true
            
        }
        
    }
    




let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCache(withUrl urlString : String) {
        
        let url = URL(string: urlString)
        
        self.image = nil
        
        
        
        // check cached image
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            
            self.image = cachedImage
            
            return
            
        }
        
        
        
        // if not, download image from url
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
                return
                
            }
            
            
            
            DispatchQueue.main.async {
                
                if let image = UIImage(data: data!) {
                    
                    imageCache.setObject(image, forKey: urlString as NSString)
                    
                    self.image = image
                    
                }
                
            }
            
            
            
        }).resume()
        
    }
    
}

