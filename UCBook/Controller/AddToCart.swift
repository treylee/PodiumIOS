//
//  AddToCart.swift
//  UCBook
//
//  Created by Trieveon Cooper on 7/9/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

//
//  AccountVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 4/17/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
import Firebase

class AddToCart : UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var name = ""
    var price = ""
    var bookList = [Book]()
    var count = 0;
    @IBOutlet weak var cartTable: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = cartTable.dequeueReusableCell(withIdentifier: "CartCell") as! CartCell
            cell.bookTitle.text = bookList[indexPath.row].title
            cell.bookPrice.text = bookList[indexPath.row].price
        let url = URL(string: self.bookList[indexPath.row].photos?[0] as! String)
        cell.bookPic.kf.setImage(with: url)
        
     
        return cell
    }
    

    @IBAction func viewBook(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "PostingBoard", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "BookDetailsVC") as! BookDetailsVC
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "PostingBoard", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "BookDetailsVC") as! BookDetailsVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.bookISBN?.text = bookList[indexPath.row].isbn
        vc.bookCondition?.text = bookList[indexPath.row].title
        vc.subjectText =
            bookList[indexPath.row].title!
        vc.price =
            bookList[indexPath.row].price!
        vc.bookDescription?.text =
            bookList[indexPath.row].description
        
        present(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTable.delegate = self
        cartTable.dataSource = self
        /*
         let picTap = UITapGestureRecognizer()
         picTap.addTarget(self, action: "profileImageHasBeenTapped")
         
         cell.posterPic.addGestureRecognizer(picTap)
         */
        let db = Firestore.firestore()

        db.collection("cart")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        var newBook: Book = Book(dictionary: document.data())!
                        
                        self.bookList.append(newBook)
                        print("printing bookList")
                        print(self.bookList[0].title,"booklist 0")
                    }
                    self.cartTable.reloadData()
                    
                    print("reloading data")
                }
        }
        
    }
 

  
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // can ontroll the number of items in each seciton
        return bookList.count
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
    
    
}




