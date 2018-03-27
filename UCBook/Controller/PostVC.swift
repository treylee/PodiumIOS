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
    var counter = 500

// var instead of let so can mutate
    // add more expandables to create more books
    // add names to create more rows in each book section
    var twodimensionalArray = [
        Expandable(isExpanded: false,names: ["booby","tim","john","smith","xx","sda","sdada" ]),
            Expandable(isExpanded: false,names: ["booby","tim","john","smith","xx","sda","sdada" ]),
            Expandable(isExpanded: false,names: ["booby","tim","john","smith","xx","sda","sdada" ]),
             Expandable(isExpanded: false,names: ["booby","tim","john","smith","xx","sda","sdada"]),
    ]
    var showIndexPaths = false
    override func viewDidLoad(){
        super.viewDidLoad()
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
       // can ontroll the number of items in each seciton
        if !twodimensionalArray[section].isExpanded {
            return 0
        }
        return twodimensionalArray[section].names.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twodimensionalArray.count
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
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        print("in header section:",section)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(_:)))
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader") as? BookHeaderCell
        cell?.bookPrice.text = "100"
        cell?.bookTitle.text = "SomeBook"
        cell?.bookPicture.image = img
        cell?.bookTitle.textColor = UIColor.lightGray
        cell?.bookPrice.textColor = UIColor.lightGray
        cell?.moneySign.textColor = UIColor.lightGray

      //  cell?.bookPicture.layer.masksToBounds = false
      //  cell?.bookPicture.layer.cornerRadius = (cell?.bookPicture.frame.height)!/6
     //   cell?.bookPicture.clipsToBounds = true
        if selectedHeader ==  section {
            cell?.bookTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
            cell?.bookPrice.font = UIFont.boldSystemFont(ofSize: 20.0)
            cell?.moneySign.font =   UIFont.boldSystemFont(ofSize: 20.0)
          //  cell?.bookPicture.borderWidth = 3
           // cell?.layer.borderColor = UIColor.black.cgColor
        }
        let initialScale: CGFloat = 1.2
        let duration: TimeInterval = 0.5
        
   
        cell?.addGestureRecognizer(tap)
        cell?.isUserInteractionEnabled = true
        cell?.tag = section
        return cell
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
        } else if indexPath.row == 2 {
                     let cell = tableView.dequeueReusableCell(withIdentifier: "Row2", for: indexPath) as! InstructorCell
            return cell;
        }else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Row3", for: indexPath) as! ISBNCell
            return cell;
        }else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Row4", for: indexPath) as! ConditionCell
            return cell;
        }else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Row5", for: indexPath) as! MeetingLocationCell
            return cell;
        }else if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Row6", for: indexPath) as! ReviewCell
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
