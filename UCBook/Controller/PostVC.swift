//
//  PostVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 3/2/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit

class PostVC: UITableViewController {
    let cellId = "cellId"
    var selectedHeader = -1;
    var bookShrinkSize = 0
    
// var instead of let so can mutate
    var twodimensionalArray = [
        Expandable(isExpanded: false,names: ["booby","tim","john","smith","xx" ]),
        Expandable(isExpanded: false,names: ["tooby","tim","john","smith","xx" ]),
        Expandable(isExpanded: false,names: ["aooby","tim","john","smith","xx" ]),
        Expandable(isExpanded: false,names: ["vooby","tim","john","smith","xx" ]),
    ]
    var showIndexPaths = false
    override func viewDidLoad(){
        super.viewDidLoad()
 
        // register the cell identifier
        //default cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
       // tableView.register(BookCell.self, forCellReuseIdentifier: cellId)
     

        tableView.rowHeight = UITableViewAutomaticDimension
    }

    @objc func handleShowIndexPath(){
        var indexPathsToReload = [IndexPath]()
        for section in twodimensionalArray.indices {
            for row in twodimensionalArray[section].names.indices {
                print(section,row)
                let indexPath = IndexPath(row:row,section:section)
                indexPathsToReload.append(indexPath)
                }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // can controll the number of items in each seciton
        if !twodimensionalArray[section].isExpanded {
            return 0
        }
        return twodimensionalArray[section].names.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twodimensionalArray.count
    }
    


 
   

    
    let img = UIImage(named: "008-twitter")!
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        print("in header section:")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(_:)))
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader") as? BookHeaderCell
        cell?.bookPrice.text = "100"
        cell?.bookTitle.text = "SomeBook"
        cell?.bookPicture.image = img
        cell?.bookTitle.textColor = UIColor.lightGray
        cell?.bookPrice.textColor = UIColor.lightGray

        print(section,selectedHeader, "testing")
        if selectedHeader ==  section {
            cell?.bookTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
            cell?.bookPrice.font = UIFont.boldSystemFont(ofSize: 20.0)

        }
        cell?.addGestureRecognizer(tap)
        cell?.isUserInteractionEnabled = true
        cell?.tag = section
        return cell
    }
    // reload table is necessary in reloading the expandable views
    @objc func handleTap2(_ sender: UITapGestureRecognizer) {
        
        let section = sender.view?.tag
    
        // hides all other cells but the current selection and ones that already closed.
        print(twodimensionalArray.indices,"THE INDICIDES ")
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
            tableView.insertRows(at: indexPaths, with: .fade)
            tableView.reloadData()

            //scrolls to top of section that was clicked manage this
            /*
            let indexPath = IndexPath(row:0,section:section!)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                */
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
    } else {
    

    }
    }
    }

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
               let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader") as? BookHeaderCell
        let width = view.frame.size.width
    
        var cellWidth = cell?.bookPicture.image?.size.width
        var cellHeight = cell?.bookPicture.image?.size.height
        if cellWidth != nil && cellHeight != nil {
            return width / (cellHeight! * cellWidth!)
        }else {
            return width/2
        }
        
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
       
            return 81
        }
        return 44
    }
    var count = 0;
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            print("setting height")
            let cell = tableView.dequeueReusableCell(withIdentifier: "Row0", for: indexPath) as! BookCellZero
            cell.posterPic.layer.borderWidth = 1
            cell.posterPic.layer.borderColor = UIColor.white.cgColor
            cell.posterPic.backgroundColor = UIColor.gray
            cell.posterPic.layer.masksToBounds = false
            cell.posterPic.layer.cornerRadius = cell.posterPic.frame.height/2
            cell.posterPic.clipsToBounds = true
            cell.posterPic.image = UIImage(named: "face id")
            //adding gesture recognizer alternative to IBaction
            cell.posterPic.isUserInteractionEnabled = true
            let picTap = UITapGestureRecognizer()
            picTap.addTarget(self, action: "profileImageHasBeenTapped")
            
            cell.posterPic.addGestureRecognizer(picTap)
            cell.posterName.text = "Sam C."
            count += 1
            return cell
        }
     let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        // access array and display
        //choose either names if section == 0 if not choose names2
        //let name  = indexPath.section == 0 ? names[indexPath.row] : names2[indexPath.row]
        let name  = twodimensionalArray[indexPath.section].names[indexPath.row]
        cell.textLabel?.text = name
       // [tableView scrollToRowAtIndexPath:selectedCellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

        return cell
    }
    
}
