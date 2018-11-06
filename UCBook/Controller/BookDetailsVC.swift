//
//  BookDetailsVC.swift
//  UCBook
//
//  Created by Trey Cooper on 10/31/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreData
import AVKit

class BookDetailsVC: UIViewController {

    var subjectText = ""
    var courseText = ""
    var bookID = ""
    var price = ""
    var photos = [String]()
    var sellerPhoto = ""
    var comments = ""
    var isbn = ""
    var name = ""
    

    
    @IBOutlet weak var sellerPicture: UIImageView!
    
    @IBOutlet weak var bookCondition: UILabel!
    
    @IBOutlet weak var bookISBN: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookPrice: UILabel!
    @IBOutlet weak var bookPicture: UIImageView!
    
    @IBOutlet weak var sellerName: UILabel!
    
    @IBOutlet weak var bookDescription: UILabel!
    
    @IBOutlet weak var close: UIImageView!
    
    @IBOutlet weak var contactButton: UIImageView!
    override func viewDidLoad() {
        bookTitle.text = subjectText
        bookPrice.text = price
        bookDescription.text = comments
        bookISBN.text = isbn
        sellerName.text = name
        
        let url = URL(string:photos[0])
        bookPicture.kf.setImage(with: url)
        
        
        let url2 = URL(string:sellerPhoto)
        sellerPicture.kf.setImage(with: url)
      
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(toMessages(tapGestureRecognizer:)))
        contactButton.isUserInteractionEnabled = true

        contactButton.addGestureRecognizer(tapGestureRecognizer2)
        
        
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("habba")
        dismiss(animated: true, completion: nil)
        
    }
    @objc func toMessages(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ChatBoard", bundle: nil)
        // the identifier is the storyboardID near under the class name section
        let vc = storyBoard.instantiateViewController(withIdentifier: "FriendListVC") as! FriendListVC
        dismiss(animated: true, completion: {
              self.navigationController?.pushViewController(vc, animated: true)
        })
 
       
        present(vc, animated: false)

    }
}


