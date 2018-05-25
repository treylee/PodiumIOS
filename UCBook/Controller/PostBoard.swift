//
//  PostBoard.swift
//  UCBook
//
//  Created by Trieveon Cooper on 3/24/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import Foundation
import UIKit

class PostBoard: UITableViewController {
    
lazy var searchBar = UISearchBar(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Search"
        
        navigationItem.titleView = searchBar
        // First Header
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        header.backgroundColor = .red
        tableView.tableHeaderView = header
        // First Footer
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        footer.backgroundColor = .red
        tableView.tableFooterView = footer;
        
        self.automaticallyAdjustsScrollViewInsets = false

        
        
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        v.backgroundColor = .red
        return v;
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .white
        let segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 30))
        segmentedControl.insertSegment(withTitle: "Price", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Newest", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Quality", at: 2, animated: false)
        v.addSubview(segmentedControl)
        return v
    }

    
}
