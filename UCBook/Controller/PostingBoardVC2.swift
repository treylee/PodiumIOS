//
//  PostingBoardVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/13/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit

class PostingBoardVC2: UIViewController {
    var titleList = [ "1","2","3","4","5"]

    @IBOutlet weak var collectionView: UICollectionView!
    
    //10 is the spacing between the columns
    //if there was 3 columbs = 20 2 = 10 min spacing found in inspector ruler
    // function makes layout universal on every device
    override func viewDidLoad() {
        super.viewDidLoad()
        //let width = (view.frame.size.width) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
       // layout.itemSize = CGSize(width:width,height:view.frame.size.height-10)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(PostingBoardVC2.handleLongGesture))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    
    // MARK: - Gesture recogniser
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer)
    {
        switch(gesture.state)
        {
        case .began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else
            {
                break
            }
            
            self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            
        case .changed:
            self.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            
        case .ended:
            self.collectionView.endInteractiveMovement()
            
        default:
            self.collectionView.cancelInteractiveMovement()
        }
    }
}


extension PostingBoardVC2: UICollectionViewDelegate,UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    // tag 100 is title label in collection cell
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell2", for: indexPath )
        if let label = cell.viewWithTag(2) as? UILabel {
            label.text = titleList[indexPath.row]
            
        }
        
        
        
        return cell
    }
}
    
  
        
    
    
    




