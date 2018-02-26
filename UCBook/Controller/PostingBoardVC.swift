//
//  PostingBoardVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/13/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit

class PostingBoardVC: UIViewController {
    var titleList = [ "1","2","3","4","5"]
    var imageList =
    {
        
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    //10 is the spacing between the columns
    //if there was 3 columbs = 20 2 = 10 min spacing found in inspector ruler
    // function makes layout universal on every device
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = (view.frame.size.width) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width:width-40,height:width+40)
        
    }
}
extension PostingBoardVC: UICollectionViewDelegate,UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleList.count
    }
    // tag 100 is title label in collection cell
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath )
        if let label = cell.viewWithTag(100) as? UILabel {
            label.text = titleList[indexPath.row]
            
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

