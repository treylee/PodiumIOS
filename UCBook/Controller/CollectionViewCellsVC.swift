//
//  CollectionViewCellsV C.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/14/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit

class CollectionViewCellsVC: UIViewController,UICollectionViewDelegate,
UICollectionViewDataSource{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var selectedItem: UIImageView!
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectView", for: indexPath) as! CollectionViewCells
        cell.pic.image = UIImage(named: "FullSizeRender")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }
    }

