//
//  PostVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 3/2/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class PostVC: UITableViewController {
   
    
    var bookList = [Book]()
    var test = ""
    var subject = ""
    var course = ""
    let cellId = "cellId"
    var selectedHeader = -1;
    var bookShrinkSize = 0
    var counter = 500
    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    lazy var searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    private var roundButton = UIButton()

    let storage = Storage.storage()
    
// var instead of let so can mutate
    // add more expandables to create more books
    // add names to create more rows in each book section
    var twodimensionalArray = [Expandable]()
    @objc func clickedSearch(_ sender:UIButton){
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "PostingBoard", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "addToCart")
        //   vc.modalTransitionStyle = .flipHorizontal
        navigationController?.pushViewController(vc, animated: false)

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if roundButton.superview != nil {
            DispatchQueue.main.async {
                self.roundButton.isHidden = true
            }
        }
    }
    @objc func buttonTapped(_ sender : UIButton){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "SearchPopupVC") as! SearchPopupVC
        vc.view.backgroundColor = .blue
        vc.modalPresentationStyle = .overFullScreen
      //  vc.delegate = self as! sendDataToViewProtocol
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
        
        present(vc, animated: true)

    }
    var showIndexPaths = false
    func createFloatingButton() {
        roundButton = UIButton(type: .custom)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        roundButton.backgroundColor = .white
        // Make sure you replace the name of the image:
        roundButton.setImage(UIImage(named:"bwSearchButton"), for: .normal)
        
        // Make sure to create a function and replace DOTHISONTAP with your own function:
        roundButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        // We're manipulating the UI, must be on the main thread:
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(self.roundButton)
                NSLayoutConstraint.activate([
                    keyWindow.trailingAnchor.constraint(equalTo: self.roundButton.trailingAnchor, constant: 15),
                    keyWindow.bottomAnchor.constraint(equalTo: self.roundButton.bottomAnchor, constant: 45),
                    self.roundButton.widthAnchor.constraint(equalToConstant: 30),
                    self.roundButton.heightAnchor.constraint(equalToConstant: 30)])
            }
            // Make the button round:
            self.roundButton.layer.cornerRadius = 37.5
            // Add a black shadow:
            self.roundButton.layer.shadowColor = UIColor.black.cgColor
            self.roundButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            self.roundButton.layer.masksToBounds = false
            self.roundButton.layer.shadowRadius = 2.0
            self.roundButton.layer.shadowOpacity = 0.5
            // Add a pulsing animation to draw attention to button:
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.duration = 0.4
            scaleAnimation.repeatCount = .greatestFiniteMagnitude
            scaleAnimation.autoreverses = true
            scaleAnimation.fromValue = 1.0;
            scaleAnimation.toValue = 1.05;
            self.roundButton.layer.add(scaleAnimation, forKey: "scale")
        }
    }
   
    override func viewDidLoad(){
        super.viewDidLoad()
       createFloatingButton()
      
        print("loading")
        let db = Firestore.firestore()
    
        if course != "" && subject != "" {
        print(subject,"course:",course, "the subject and courses that were passed hipefully")
            
        db.collection("books").document("byCourse").collection(course)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
            
                        var newBook: Book = Book(dictionary: document.data())!
                       
                        self.bookList.append(newBook)
                            print("printing bookList")
                        print(self.bookList[0].title,"booklist 0")
                        self.twodimensionalArray.append(Expandable(isExpanded: false,names: ["tim","tim","john","smith","xx","sda","sdada"]))
                        }
                    
                        self.tableView.reloadData()
                    
                    print("reloading data")
                    }
                }
        

   
        print("recieved data",subject,course)
        } else {
            
            db.collection("books").document("all").collection("recent")
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            var newBook: Book = Book(dictionary: document.data())!
                            print("in no selection")
                            self.bookList.append(newBook)
                            self.twodimensionalArray.append(Expandable(isExpanded: false,names: ["tim","tim","john","smith","xx","sda","sdada"]))
                        }
                        
                        self.tableView.reloadData()
                        
                        print("reloading data")
                    }
            }
            
            
            
        }
 
        //UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
     
        searchBar.placeholder = "Search"
        searchBar.clipsToBounds = true
        searchBar.contentMode = UIViewContentMode.scaleAspectFit
        
        searchButton.setTitle("Search", for: .normal)
        searchButton.clipsToBounds = true
        searchButton.backgroundColor = UIColor.red
        searchButton.contentMode = UIViewContentMode.scaleAspectFit
     //  navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
     //   navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
       // navigationItem.titleView = searchBar
        
        let btn1 = UIButton(type: .custom)
     
        btn1.clipsToBounds = true
    
        btn1.frame = CGRect(x: 360, y: 0, width: 30, height: 30)
        btn1.tintColor = UIColor.red
        btn1.backgroundColor = UIColor.red
        btn1.setTitle("0", for: .normal)

        btn1.addTarget(self, action: #selector(clickedSearch), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = nil
        //self.navigationItem.title = nil
        let item1 = UIBarButtonItem(customView: btn1)
        
        
      self.navigationItem.setRightBarButtonItems([item1], animated: true)
      
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 100, height: 100))
        var view1: UIView = UIView.init(frame: rect);
        var label: UILabel = UILabel.init(frame: rect)
        label.text   = "Some Header Text Fam"
        view1.addSubview(label);
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "Row7") as! TableHeaderCell
        
        
        
        self.tableView.tableHeaderView = cell
        */
        /*
        let cell2 =
            tableView.dequeueReusableCell(withIdentifier: "Row8") as! TableFooterCell
        self.tableView.tableFooterView = cell2
        */
        //tableView.tableHeaderView.add
        
        
        // register the cell identifier
        //default cell
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        //tableView.register(BookCell.self, forCellReuseIdentifier: "BookCell")
     
/*
        tableView.rowHeight = UITableViewAutomaticDimension
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        footer.backgroundColor = .red
        tableView.tableFooterView = footer;
        */
        tableView?.contentInset = UIEdgeInsets(top: 75, left: 0, bottom: 75, right: 0)

        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.roundButton.isHidden = false
        
       

    }
    //only fits 6 atm
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
  
    }
    // 6 is represented by the number of sections within a book selection for example reviews,comments,etc
    @objc func handleShowIndexPath(){
        var indexPathsToReload = [IndexPath]()
        for section in 0...6 {
            for row in 0...6 {
                print(section,row)
                let indexPath = IndexPath(row:row,section:section)
                indexPathsToReload.append(indexPath)
                }
        }
    }
    /*
    @objc func cartImageClick(_ sender: UITapGestureRecognizer){
        print("cart image click")
        cart.title = "\(Int(cart.title!)!+1)"
      

        //animation(tempView: sender)
        
    }
    */
   

    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // can ontroll the number of items in each seciton
        if !twodimensionalArray[section].isExpanded {
            return 0
        }
        return twodimensionalArray[section].names.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twodimensionalArray.count
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader") as? BookHeaderCell
        var height = cell?.bookPicture.frame.size.height
        var width = cell?.bookPicture.frame.size.width
        
        let footerView = UIView()
        let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: footerView.frame.height, width: width!, height: 1))
        separatorView.backgroundColor = UIColor.red
        footerView.addSubview(separatorView)
        return footerView
    }
    
/*
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        /*
        let v = UIView()
        v.backgroundColor = .white
        let segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 30))
        segmentedControl.insertSegment(withTitle: "Price", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Newest", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Quality", at: 2, animated: false)
        v.addSubview(segmentedControl)
        return v
 */
        let cell2 =
            tableView.dequeueReusableCell(withIdentifier: "Row8") as! TableFooterCell
        self.tableView.tableFooterView = cell2
        return cell2;
 
 }
 
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60;
    }
   */
    let img = UIImage(named: "chex")!
    var imgList: [String] = ["book5cover","book5cover", "book4cover","book3cover","book4cover","book1cover",]
  
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        print("in header section:",section,"booklist count",bookList.count )
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(_:)))
        let storageRef = storage.reference()
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader") as? BookHeaderCell
        cell?.bookPrice.text = "100"
        cell?.bookTitle.text = "test"
        if bookList.count > 0 {
            print(bookList[0].title,"checking this value")
                cell?.bookTitle.text = bookList[section].title
                cell?.bookPicture.image = UIImage(named: imgList[section])
                cell?.bookPrice.text = bookList[section].price
          //  let imageRef = storageRef.child(bookList[0].photos![0] as! String)
         //   let imageView: UIImageView = (cell?.bookPicture)!
         //   let placeholderImage = UIImage(named: "FullSizeRender")
          //  imageView.sd_setImage(with: imageRef, placeholderImage: placeholderImage)

        }
        cell?.bookTitle.textColor = UIColor.lightGray
        cell?.bookPrice.textColor = UIColor.lightGray
        cell?.moneySign.textColor = UIColor.lightGray
        
    

        //  cell?.bookPicture.layer.masksToBounds = false
      //  cell?.bookPicture.layer.cornerRadius = (cell?.bookPicture.frame.height)!/6
     //   cell?.bookPicture.clipsToBounds = true
        if selectedHeader ==  section  {
            cell?.bookTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
            cell?.bookPrice.font = UIFont.boldSystemFont(ofSize: 20.0)
            cell?.moneySign.font =   UIFont.boldSystemFont(ofSize: 20.0)
            //  cell?.bookPicture.borderWidth = 3
           // cell?.layer.borderColor = UIColor.black.cgColor
            print("esslected header",selectedHeader)
        }
        let initialScale: CGFloat = 1.2
        let duration: TimeInterval = 0.5
        
   
        cell?.addGestureRecognizer(tap)
        cell?.isUserInteractionEnabled = true
        cell?.tag = section
     

      
        return cell
    }
    func ResizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    // reload table is necessary in reloading the expandable views
    @objc func handleTap2(_ sender: UITapGestureRecognizer) {
        
        let section = sender.view?.tag
    

        // hides all other cells but the current selection and ones that already closed.
        print("the section pressed",section)
        for sections in (twodimensionalArray.indices){
            if twodimensionalArray[sections].names.indices.count > 0 && sections != section {
             print(sections,"CURRENT INDICES",twodimensionalArray[sections].names.indices.count)
                hideAllRows(section: sections)
            }
        }
        var indexPaths = [IndexPath]()
        
        //tag of section set in viewforheadersection
         print("header was touched",section!)
         selectedHeader = section!
        for row in twodimensionalArray[section!].names.indices {
            let indexPath = IndexPath(row:row,section:section!)
            indexPaths.append(indexPath)
        }
        let isExpanded = twodimensionalArray[section!].isExpanded
          twodimensionalArray[section!].isExpanded = !isExpanded
        print("isExpanded is", isExpanded)

        
        if isExpanded {
            print("deleting currently expanded")
            tableView.deleteRows(at: indexPaths, with: .fade)
            tableView.reloadData()

        } else {
            
            print("inserting because expanded")
            tableView.insertRows(at: indexPaths, with: .bottom)
            tableView.reloadData()


            //scrolls to top of section that was clicked manage this
           
         //   let group = DispatchGroup()
         //   group.enter()
            DispatchQueue.main.async {
                let indexPath = IndexPath(row:0,section:section!)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                //group.leave()
            }
            /*
            group.notify(queue: .main) {
                print("finished scroll:ing:")
                self.changeHeight = true
                self.tableView.reloadData()
                
            }*/
        }
     
        //twodimensionalArray[section!].names.removeAll()
       // tableView.deleteRows(at: indexPaths  , with: .fade)
    }


    func hideAllRows(section : Int) {
    tableView.reloadData()
        if twodimensionalArray[section].isExpanded == true {
    var indexPaths = [IndexPath]()
    
    //tag of section set in viewforheadersection
    print("ITS EXPANDED GOTTA ",section)
    for row in twodimensionalArray[section].names.indices {
    let indexPath = IndexPath(row:row,section:section)
    indexPaths.append(indexPath)
    }
    let isExpanded = twodimensionalArray[section].isExpanded
    twodimensionalArray[section].isExpanded = !isExpanded
    print("isExpanded is", isExpanded)
    
    
    if isExpanded {
    print("deleting currently expanded")
    tableView.deleteRows(at: indexPaths, with: .fade)
        tableView.reloadData()
    } else {
    

    }
     }
    }

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
 
        let width = view.frame.size.width
     
            return width - 40
        
        
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row) {
            case 0:
                return 81
            case 1:
             return 68
            default:
            return 68
        }
    }
 

    @IBAction func cartClicked(_ sender: UIButton) {
       
        var docData: [String: Any] = [
            "title": bookList[selectedHeader].title,
            "isbn" : bookList[selectedHeader].isbn ,
            "photos" : bookList[selectedHeader].photos,
            "meetingPlace": bookList[selectedHeader].meetingPlace,
            "price":bookList[selectedHeader].price
        ]
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        var ref = db.collection("cart").addDocument(data: docData)
        
        
      //  print("clicked",self.navigationItem.rightBarButtonItem?.title)

        let buttonPosition : CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)!
        
 let cell = tableView.dequeueReusableCell(withIdentifier: "Row8", for: indexPath) as! CartOrBuyCell
    
        let imageViewPosition : CGPoint = cell.cartButton.convert(cell.buyImageButton.bounds.origin, to: self.view)
        
        
        let imgViewTemp = UIImageView(frame: CGRect(x: imageViewPosition.x, y: imageViewPosition.y, width: cell.buyImageButton.frame.size.width, height: cell.buyImageButton.frame.size.height))
        
        imgViewTemp.image = cell.cartButton.imageView?.image
        
        animation(tempView: imgViewTemp)
    }
    
    func animation(tempView : UIView)  {
        self.view.addSubview(tempView)
        UIView.animate(withDuration: 1.0,
                       animations: {
                        tempView.animationZoom(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            
            UIView.animate(withDuration: 0.5, animations: {
                
                tempView.animationZoom(scaleX: 0.2, y: 0.2)
                tempView.animationRoted(angle: CGFloat(Double.pi))
                
                tempView.frame.origin.x = tempView.frame.origin.x
                tempView.frame.origin.y = tempView.frame.origin.y + 400
                
            }, completion: { _ in
                
                tempView.removeFromSuperview()
                
                UIView.animate(withDuration: 1.0, animations: {
                    /*
                    self.counterItem += 1
                    self.lableNoOfCartItem.text = "\(self.counterItem)"
                    */
                    tempView.animationZoom(scaleX: 1.4, y: 1.4)
                }, completion: {_ in
                    
                    tempView.animationZoom(scaleX: 1.0, y: 1.0)
                })
                
            })
            
        })
    }
    var count = 0;
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexpath",indexPath.row)
        if indexPath.row == 0 {
            print("setting height")
            let cell = tableView.dequeueReusableCell(withIdentifier: "Row0", for: indexPath) as! BookCellZero
            cell.posterPic.layer.borderWidth = 1
            cell.posterPic.layer.borderColor = UIColor.white.cgColor
            cell.posterPic.backgroundColor = UIColor.gray
            cell.posterPic.layer.masksToBounds = false
            cell.posterPic.layer.cornerRadius = cell.posterPic.frame.height/2
            cell.posterPic.clipsToBounds = true
            cell.posterPic.image = UIImage(named: "FullSizeRender")
            //adding gesture recognizer alternative to IBaction
            cell.posterPic.isUserInteractionEnabled = true
            let picTap = UITapGestureRecognizer()
            picTap.addTarget(self, action: "profileImageHasBeenTapped")
            
            cell.posterPic.addGestureRecognizer(picTap)
            cell.posterName.text = "Sam C."
            // removes cell seperator from bottom
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
            return cell
        }else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
            
            let name  = twodimensionalArray[indexPath.section].names[indexPath.row]
            
            let label = UILabel(frame: CGRect(x:3, y: 30, width: UIScreen.main.bounds.width , height: 40))


            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.text =
                "   This is a very long description of a very boring book that I happen to read on tuesdays :( "
            cell.textLabel?.textColor = UIColor.lightGray
            
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Row3", for: indexPath) as! ISBNCell
            return cell;
        }else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Row4", for: indexPath) as! ConditionCell
            return cell;
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Row5", for: indexPath) as! MeetingLocationCell
            return cell;
        }else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Row6", for: indexPath) as! ReviewCell
            return cell;
        }else if indexPath.row == 6 {
            print("indexpath row is 8")
            let cell = tableView.dequeueReusableCell(withIdentifier: "Row8", for: indexPath) as! CartOrBuyCell
            /*
            cell.buyImageButton.isUserInteractionEnabled = true
            cell.cartImageButton.isUserInteractionEnabled = true
            
            let cartTap = UITapGestureRecognizer(target: self, action: #selector(self.cartImageClick(_:)))
            
            
            cell.cartImageButton.addGestureRecognizer(cartTap)
            */
            return cell;
 
        }

        
        
     let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        
        let name  = twodimensionalArray[indexPath.section].names[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text =  name


        return cell
    }
    
}

class ScaledHeightImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
    
}
extension UIView{
    func animationZoom(scaleX: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: y)
    }
    
    func animationRoted(angle : CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }
}
