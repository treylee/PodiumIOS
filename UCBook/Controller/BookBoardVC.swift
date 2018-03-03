//
//  PostingBoardVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/13/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit

class BookBoardVC: UIViewController {
    var titleList = [ "Harry Potter","Rich Dar Poor Dad","Cooking Essentials Family","Insta Fame for Dummeis","Knowledge is Power "]
    var priceList = [ "112","243","231","411","500"]

    var imageList =
    {
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //10 is the spacing between the columns
    //if there was 3 columbs = 20 2 = 10 min spacing found in inspector ruler
    // function makes layout universal on every device
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = (view.frame.size.width)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width:width,height:width)
        
        
    }
}
extension BookBoardVC: UICollectionViewDelegate,UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(titleList.count)
        return titleList.count
    }
    // tag 11 is price 12 is title
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath )
        if let label = cell.viewWithTag(12) as? UILabel {
            print("success1")

            label.text = titleList[indexPath.row]
            
        }
        if let label = cell.viewWithTag(11) as? UILabel {
            print("success2")

            label.text = priceList[indexPath.row]
            }
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "collectionViewHeader", for: indexPath)
            
            headerView.backgroundColor = UIColor.green
            print("testing")
            
            return headerView
        }
        print("dada")
        return UICollectionReusableView()
        
    }
    
    
}

